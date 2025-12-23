BEGIN;

TRUNCATE TABLE order_status_history, reviews, deliveries, order_items, orders, products, categories, manufacturers, employees, customers CASCADE;

ALTER SEQUENCE customers_customer_id_seq RESTART WITH 1;
ALTER SEQUENCE employees_employee_id_seq RESTART WITH 1;
ALTER SEQUENCE categories_category_id_seq RESTART WITH 1;
ALTER SEQUENCE manufacturers_manufacturer_id_seq RESTART WITH 1;
ALTER SEQUENCE products_product_id_seq RESTART WITH 1;
ALTER SEQUENCE orders_order_id_seq RESTART WITH 1;
ALTER SEQUENCE order_items_order_item_id_seq RESTART WITH 1;
ALTER SEQUENCE orders_order_number_seq RESTART WITH 1000;

INSERT INTO categories (name, slug, description) VALUES
('Смартфоны', 'smartphones', 'Смартфоны и гаджеты'),
('Ноутбуки', 'laptops', 'Ноутбуки и компьютеры'),
('Телевизоры', 'tv', 'Телевизоры и аудиотехника');

INSERT INTO manufacturers (name, country) VALUES
('Apple', 'США'),
('Samsung', 'Южная Корея'),
('Xiaomi', 'Китай');

INSERT INTO products (sku, name, category_id, manufacturer_id, base_price, current_price, stock_quantity, published_at) VALUES
('IPHONE-15', 'iPhone 15', 1, 1, 89999, 84999, 10, NOW()),
('GALAXY-S24', 'Samsung Galaxy S24', 1, 2, 79999, 74999, 15, NOW()),
('XIAOMI-14', 'Xiaomi 14', 1, 3, 59999, 54999, 20, NOW()),
('MACBOOK-AIR', 'MacBook Air M2', 2, 1, 129999, 124999, 5, NOW());


INSERT INTO customers (full_name, email, phone) VALUES
('Иванов Иван', 'ivanov@test.com', '+79161234567'),
('Петрова Мария', 'petrova@test.com', '+79167654321'),
('Сидоров Алексей', 'sidorov@test.com', '+79031112233');

INSERT INTO employees (username, password_hash, full_name, email, role, hire_date) VALUES
('admin', 'hash1', 'Админ Админович', 'admin@store.com', 'admin', '2023-01-15'),
('manager', 'hash2', 'Менеджер Менеджерович', 'manager@store.com', 'manager', '2023-03-20');

INSERT INTO orders (customer_id, employee_id, status, payment_status, subtotal_amount, shipping_amount, total_amount) VALUES
(1, 2, 'delivered', 'paid', 84999, 500, 85499),
(2, 2, 'shipped', 'paid', 124999, 500, 125499),
(3, 2, 'processing', 'pending', 74999, 500, 75499);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 84999), 
(2, 4, 1, 124999),
(3, 2, 1, 74999);  

INSERT INTO deliveries (order_id, delivery_address, recipient_name, recipient_phone, delivery_method, delivery_cost, status) VALUES
(1, '{"city": "Москва"}', 'Иванов Иван', '+79161234567', 'courier', 500, 'delivered'),
(2, '{"city": "СПб"}', 'Петрова Мария', '+79167654321', 'post', 500, 'in_transit');

INSERT INTO reviews (product_id, customer_id, rating, comment, status) VALUES
(1, 1, 5, 'Отличный телефон!', 'approved'),
(4, 2, 4, 'Хороший ноутбук', 'approved');

INSERT INTO order_status_history (order_id, old_status, new_status, changed_by_type, change_reason) VALUES
(1, NULL, 'created', 'system', 'Создание заказа'),
(1, 'created', 'paid', 'customer', 'Оплата онлайн'),
(1, 'paid', 'delivered', 'employee', 'Доставлен'),
(2, NULL, 'created', 'system', 'Создание заказа'),
(2, 'created', 'paid', 'customer', 'Оплата онлайн'),
(2, 'paid', 'shipped', 'employee', 'Отправлен');

COMMIT;