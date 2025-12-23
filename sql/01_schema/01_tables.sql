DROP TABLE IF EXISTS order_status_history CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS deliveries CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS manufacturers CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
        CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    phone VARCHAR(50),
    billing_address JSONB,
    registration_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_active_date TIMESTAMPTZ,
    account_status VARCHAR(20) DEFAULT 'active'
        CHECK (account_status IN ('active', 'inactive', 'blocked')),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CHECK (updated_at IS NULL OR updated_at >= created_at)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(30) NOT NULL
        CHECK (role IN ('admin', 'manager', 'warehouse', 'courier', 'support', 'analyst')),
    department VARCHAR(100),
    hire_date DATE NOT NULL,
    termination_date DATE,
    salary DECIMAL(12,2) CHECK (salary >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CHECK (termination_date IS NULL OR termination_date >= hire_date)
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    parent_category_id INTEGER REFERENCES categories(category_id) ON DELETE SET NULL,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    country VARCHAR(100),
    website VARCHAR(255),
    description TEXT,
    logo_url VARCHAR(500),
    founded_year INTEGER
        CHECK (founded_year IS NULL OR founded_year BETWEEN 1800 AND EXTRACT(YEAR FROM CURRENT_DATE)),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(500) NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(category_id),
    manufacturer_id INTEGER NOT NULL REFERENCES manufacturers(manufacturer_id),
    short_description TEXT,
    full_description TEXT,
    base_price DECIMAL(12,2) NOT NULL CHECK (base_price >= 0),
    current_price DECIMAL(12,2) NOT NULL CHECK (current_price >= 0),
    cost_price DECIMAL(12,2) CHECK (cost_price IS NULL OR cost_price >= 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    reserved_quantity INTEGER NOT NULL DEFAULT 0 CHECK (reserved_quantity >= 0 AND reserved_quantity <= stock_quantity),
    min_stock_level INTEGER DEFAULT 5 CHECK (min_stock_level >= 0),
    specifications JSONB DEFAULT '{}',
    main_image_url VARCHAR(500),
    image_gallery JSONB DEFAULT '[]',
    weight_kg DECIMAL(8,3) CHECK (weight_kg >= 0),
    dimensions JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    is_new BOOLEAN DEFAULT TRUE,
    average_rating DECIMAL(3,2) DEFAULT 0 CHECK (average_rating BETWEEN 0 AND 5),
    review_count INTEGER DEFAULT 0 CHECK (review_count >= 0),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMPTZ,
    CHECK (cost_price IS NULL OR current_price >= cost_price)
);

CREATE SEQUENCE orders_order_number_seq
    START WITH 1000
    INCREMENT BY 1
    MINVALUE 1000
    CACHE 10;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL DEFAULT (
        'ORD-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' ||
        LPAD(NEXTVAL('orders_order_number_seq')::TEXT, 6, '0')
    ),
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    employee_id INTEGER REFERENCES employees(employee_id),
    status VARCHAR(30) NOT NULL DEFAULT 'created'
        CHECK (status IN (
            'created','processing','awaiting_payment','paid',
            'packaging','shipped','delivered','cancelled',
            'returned','refunded'
        )),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (payment_status IN (
            'pending','paid','failed','refunded','partially_refunded'
        )),
    subtotal_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (subtotal_amount >= 0),
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
    tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (tax_amount >= 0),
    shipping_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (shipping_amount >= 0),
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    payment_method VARCHAR(30)
        CHECK (payment_method IN (
            'card_online','card_upon_receipt','cash',
            'bank_transfer','digital_wallet'
        )),
    payment_transaction_id VARCHAR(100),
    coupon_code VARCHAR(50),
    discount_percentage DECIMAL(5,2) CHECK (discount_percentage IS NULL OR discount_percentage BETWEEN 0 AND 100),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    paid_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    customer_notes TEXT,
    internal_notes TEXT,
    CHECK (discount_amount <= subtotal_amount),
    CHECK (total_amount = subtotal_amount - discount_amount + tax_amount + shipping_amount),
    CHECK (
        (cancelled_at IS NULL OR cancelled_at >= created_at) AND
        (completed_at IS NULL OR completed_at >= created_at) AND
        (paid_at IS NULL OR paid_at >= created_at)
    )
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12,2) NOT NULL CHECK (unit_price >= 0),
    item_discount DECIMAL(12,2) DEFAULT 0 CHECK (item_discount >= 0 AND item_discount <= quantity * unit_price),
    product_name_at_time VARCHAR(500),
    product_sku_at_time VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (order_id, product_id)
);

CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,
    order_id INTEGER UNIQUE NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    delivery_address JSONB NOT NULL,
    recipient_name VARCHAR(255) NOT NULL,
    recipient_phone VARCHAR(50) NOT NULL,
    delivery_method VARCHAR(30) NOT NULL
        CHECK (delivery_method IN ('courier','pickup','post','express')),
    delivery_cost DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (delivery_cost >= 0),
    status VARCHAR(30) NOT NULL DEFAULT 'pending'
        CHECK (status IN (
            'pending','processing','in_transit',
            'out_for_delivery','delivered','failed','returned'
        )),
    tracking_number VARCHAR(100),
    carrier VARCHAR(100),
    estimated_delivery_date DATE,
    actual_delivery_date TIMESTAMPTZ,
    shipped_at TIMESTAMPTZ,
    courier_id INTEGER REFERENCES employees(employee_id),
    courier_notes TEXT,
    delivery_signature TEXT,
    delivery_proof_url VARCHAR(500),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_status_history (
    history_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_by_type VARCHAR(20) NOT NULL
        CHECK (changed_by_type IN ('customer','employee','system','payment_gateway')),
    changed_by_id INTEGER REFERENCES employees(employee_id) ON DELETE SET NULL,
    changed_by_name VARCHAR(255),
    change_reason TEXT,
    notes TEXT,
    ip_address INET,
    user_agent TEXT,
    changed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_id INTEGER REFERENCES orders(order_id),
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(200),
    comment TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending'
        CHECK (status IN ('pending','approved','rejected','hidden')),
    moderated_by INTEGER REFERENCES employees(employee_id),
    moderation_notes TEXT,
    moderated_at TIMESTAMPTZ,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    helpful_count INTEGER DEFAULT 0 CHECK (helpful_count >= 0),
    not_helpful_count INTEGER DEFAULT 0 CHECK (not_helpful_count >= 0),
    image_urls JSONB DEFAULT '[]',
    video_url VARCHAR(500),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (product_id, customer_id)
);