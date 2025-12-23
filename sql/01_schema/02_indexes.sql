CREATE INDEX IF NOT EXISTS idx_products_category_price
    ON products(category_id, current_price);

CREATE INDEX IF NOT EXISTS idx_products_manufacturer_price
    ON products(manufacturer_id, current_price);

CREATE INDEX IF NOT EXISTS idx_products_price
    ON products(current_price);

CREATE INDEX IF NOT EXISTS idx_products_active_only
    ON products(product_id)
    WHERE is_active = TRUE;

CREATE INDEX IF NOT EXISTS idx_products_discounted
    ON products(product_id)
    WHERE current_price < base_price;

CREATE INDEX IF NOT EXISTS idx_products_low_stock
    ON products(product_id)
    WHERE stock_quantity < min_stock_level;


CREATE INDEX IF NOT EXISTS idx_orders_customer_created_at
    ON orders(customer_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_status_created_at
    ON orders(status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_paid_only
    ON orders(order_id)
    WHERE payment_status = 'paid';

CREATE INDEX IF NOT EXISTS idx_orders_number
    ON orders(order_number);


CREATE INDEX IF NOT EXISTS idx_customers_email_lower
    ON customers(LOWER(email));

CREATE INDEX IF NOT EXISTS idx_customers_registration_date
    ON customers(registration_date DESC);


CREATE INDEX IF NOT EXISTS idx_order_items_order
    ON order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product
    ON order_items(product_id);

CREATE INDEX IF NOT EXISTS idx_order_items_order_product
    ON order_items(order_id, product_id);


CREATE INDEX IF NOT EXISTS idx_reviews_product_rating
    ON reviews(product_id, rating DESC);

CREATE INDEX IF NOT EXISTS idx_reviews_customer
    ON reviews(customer_id);

CREATE INDEX IF NOT EXISTS idx_reviews_approved_only
    ON reviews(review_id)
    WHERE status = 'approved';


CREATE INDEX IF NOT EXISTS idx_deliveries_status
    ON deliveries(status);

CREATE INDEX IF NOT EXISTS idx_deliveries_tracking
    ON deliveries(tracking_number)
    WHERE tracking_number IS NOT NULL;


CREATE INDEX IF NOT EXISTS idx_status_history_order_date
    ON order_status_history(order_id, changed_at DESC);


CREATE INDEX IF NOT EXISTS idx_promo_codes_active_dates
    ON promo_codes(valid_from, valid_until)
    WHERE is_active = TRUE;

CREATE INDEX IF NOT EXISTS idx_promo_codes_code
    ON promo_codes(code);
