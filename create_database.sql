-- СОЗДАНИЕ ВСЕХ ОБЪЕКТОВ БАЗЫ ДАННЫХ:
--   psql -U postgres -d online_store -f create_database.sql

-- Удаление существующих объектов (для чистого развертывания)
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
DROP SEQUENCE IF EXISTS orders_order_number_seq CASCADE;

-- 1. СОЗДАНИЕ ТАБЛИЦ


-- ТАБЛИЦА: customers (покупатели)
-- НОРМАЛЬНАЯ ФОРМА: BCNF
-- ОБОСНОВАНИЕ: Все детерминанты являются потенциальными ключами,
--              отсутствуют транзитивные зависимости

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


-- ТАБЛИЦА: employees (сотрудники)
-- НОРМАЛЬНАЯ ФОРМА: 3НФ
-- ОБОСНОВАНИЕ: Нет частичных и транзитивных зависимостей

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


-- ТАБЛИЦА: categories (категории товаров)
-- НОРМАЛЬНАЯ ФОРМА: сознательное нарушение 3НФ
-- ОБОСНОВАНИЕ: Иерархическая структура (parent_category_id).
--              Нарушение принято для упрощения работы с деревом категорий

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


-- ТАБЛИЦА: manufacturers (производители)
-- НОРМАЛЬНАЯ ФОРМА: 3НФ

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


-- ТАБЛИЦА: products (товары)
-- НОРМАЛЬНАЯ ФОРМА: 3НФ
-- ОБОСНОВАНИЕ: Все атрибуты зависят только от первичного ключа

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


-- ТАБЛИЦА: orders (заказы)
-- НОРМАЛЬНАЯ ФОРМА: 3НФ

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


-- ТАБЛИЦА: order_items (состав заказов)
-- НОРМАЛЬНАЯ ФОРМА: 3НФ с исторической фиксацией
-- ОБОСНОВАНИЕ: unit_price дублирует цену из products для фиксации
--              исторической цены на момент покупки

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


-- ТАБЛИЦА: deliveries (доставка)
-- НОРМАЛЬНАЯ ФОРМА: 3НФ

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


-- ТАБЛИЦА: order_status_history (история статусов)
-- НОРМАЛЬНАЯ ФОРМА: 3НФ
-- ЦЕЛЬ: Аудит изменений статусов заказов

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


-- ТАБЛИЦА: reviews (отзывы)
-- НОРМАЛЬНАЯ ФОРМА: 3НФ

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

-- 2. СОЗДАНИЕ ИНДЕКСОВ (для производительности)

-- Индексы для таблицы products
CREATE INDEX idx_products_category_price ON products(category_id, current_price);
CREATE INDEX idx_products_manufacturer_price ON products(manufacturer_id, current_price);
CREATE INDEX idx_products_price ON products(current_price);
CREATE INDEX idx_products_active_only ON products(product_id) WHERE is_active = TRUE;
CREATE INDEX idx_products_discounted ON products(product_id) WHERE current_price < base_price;
CREATE INDEX idx_products_low_stock ON products(product_id) WHERE stock_quantity < min_stock_level;

-- Индексы для таблицы orders
CREATE INDEX idx_orders_customer_created_at ON orders(customer_id, created_at DESC);
CREATE INDEX idx_orders_status_created_at ON orders(status, created_at DESC);
CREATE INDEX idx_orders_paid_only ON orders(order_id) WHERE payment_status = 'paid';
CREATE INDEX idx_orders_number ON orders(order_number);

-- Индексы для таблицы customers
CREATE INDEX idx_customers_email_lower ON customers(LOWER(email));
CREATE INDEX idx_customers_registration_date ON customers(registration_date DESC);

-- Индексы для таблицы order_items
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);

-- Индексы для таблицы reviews
CREATE INDEX idx_reviews_product_rating ON reviews(product_id, rating DESC);
CREATE INDEX idx_reviews_customer ON reviews(customer_id);
CREATE INDEX idx_reviews_approved_only ON reviews(review_id) WHERE status = 'approved';

-- Индексы для таблицы deliveries
CREATE INDEX idx_deliveries_status ON deliveries(status);
CREATE INDEX idx_deliveries_tracking ON deliveries(tracking_number) WHERE tracking_number IS NOT NULL;

-- Индексы для таблицы order_status_history
CREATE INDEX idx_status_history_order_date ON order_status_history(order_id, changed_at DESC);

-- 3. СОЗДАНИЕ ХРАНИМЫХ ФУНКЦИЙ

-- Удаление существующих функций (если есть)
DROP FUNCTION IF EXISTS get_customer_total_spent(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS check_product_availability(INTEGER, INTEGER) CASCADE;
DROP FUNCTION IF EXISTS update_product_stock() CASCADE;
DROP FUNCTION IF EXISTS log_order_status_change() CASCADE;
DROP FUNCTION IF EXISTS update_product_rating() CASCADE;
DROP FUNCTION IF EXISTS update_order_totals() CASCADE;

-- ФУНКЦИЯ: get_customer_total_spent
-- ЦЕЛЬ: Возвращает общую сумму оплаченных заказов клиента

CREATE OR REPLACE FUNCTION get_customer_total_spent(p_customer_id INTEGER)
RETURNS NUMERIC(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    total_sum NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(total_amount), 0)
    INTO total_sum
    FROM orders
    WHERE customer_id = p_customer_id
      AND payment_status = 'paid';

    RETURN total_sum;
END;
$$;


-- ФУНКЦИЯ: check_product_availability
-- ЦЕЛЬ: Проверяет доступность товара на складе

CREATE OR REPLACE FUNCTION check_product_availability(
    p_product_id INTEGER,
    p_requested_quantity INTEGER
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    available_quantity INTEGER;
BEGIN
    SELECT stock_quantity - reserved_quantity
    INTO available_quantity
    FROM products
    WHERE product_id = p_product_id;

    RETURN COALESCE(available_quantity, 0) >= p_requested_quantity;
END;
$$;

-- 4. СОЗДАНИЕ ТРИГГЕРОВ


-- ТРИГГЕРНАЯ ФУНКЦИЯ: update_product_stock
-- ЦЕЛЬ: Автоматическое обновление остатков при изменении заказа

CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    delta INTEGER;
BEGIN
    IF TG_OP = 'INSERT' THEN
        delta := NEW.quantity;
    ELSIF TG_OP = 'UPDATE' THEN
        delta := NEW.quantity - OLD.quantity;
    ELSIF TG_OP = 'DELETE' THEN
        delta := -OLD.quantity;
    END IF;

    IF delta > 0 THEN
        IF NOT check_product_availability(NEW.product_id, delta) THEN
            RAISE EXCEPTION
                'Недостаточно товара на складе (product_id = %)',
                NEW.product_id;
        END IF;
    END IF;

    UPDATE products
    SET stock_quantity   = stock_quantity - delta,
        reserved_quantity = reserved_quantity + delta,
        updated_at        = CURRENT_TIMESTAMP
    WHERE product_id = COALESCE(NEW.product_id, OLD.product_id);

    RETURN COALESCE(NEW, OLD);
END;
$$;


-- ТРИГГЕРНАЯ ФУНКЦИЯ: log_order_status_change
-- ЦЕЛЬ: Логирование изменений статусов заказов для аудита

CREATE OR REPLACE FUNCTION log_order_status_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO order_status_history (
            order_id,
            old_status,
            new_status,
            changed_by_type,
            changed_by_name,
            changed_at,
            change_reason
        ) VALUES (
            NEW.order_id,
            OLD.status,
            NEW.status,
            'system',
            'system',
            CURRENT_TIMESTAMP,
            'Изменение статуса заказа'
        );
    END IF;

    RETURN NEW;
END;
$$;


-- ТРИГГЕРНАЯ ФУНКЦИЯ: update_product_rating
-- ЦЕЛЬ: Пересчет среднего рейтинга товара при изменении отзывов

CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    target_product_id INTEGER;
BEGIN
    target_product_id := COALESCE(NEW.product_id, OLD.product_id);

    UPDATE products
    SET average_rating = (
            SELECT AVG(rating)::NUMERIC(3,2)
            FROM reviews
            WHERE product_id = target_product_id
              AND status = 'approved'
        ),
        review_count = (
            SELECT COUNT(*)
            FROM reviews
            WHERE product_id = target_product_id
              AND status = 'approved'
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = target_product_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;


-- ТРИГГЕРНАЯ ФУНКЦИЯ: update_order_totals
-- ЦЕЛЬ: Пересчет сумм заказа при изменении состава

CREATE OR REPLACE FUNCTION update_order_totals()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    target_order_id INTEGER;
BEGIN
    target_order_id := COALESCE(NEW.order_id, OLD.order_id);

    UPDATE orders
    SET subtotal_amount = (
            SELECT COALESCE(SUM(quantity * unit_price), 0)
            FROM order_items
            WHERE order_id = target_order_id
        ),
        total_amount = (
            SELECT COALESCE(SUM(quantity * unit_price), 0)
            FROM order_items
            WHERE order_id = target_order_id
        ) - discount_amount + tax_amount + shipping_amount,
        updated_at = CURRENT_TIMESTAMP
    WHERE order_id = target_order_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;


-- СОЗДАНИЕ ТРИГГЕРОВ

CREATE TRIGGER trg_update_product_stock
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_product_stock();

CREATE TRIGGER trg_log_order_status
AFTER UPDATE OF status ON orders
FOR EACH ROW
EXECUTE FUNCTION log_order_status_change();

CREATE TRIGGER trg_update_product_rating
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_product_rating();

CREATE TRIGGER trg_update_order_totals
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_order_totals();

