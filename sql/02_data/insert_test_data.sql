BEGIN;

INSERT INTO categories (name, slug, description, sort_order) VALUES
('Смартфоны', 'smartphones', 'Смартфоны и мобильные устройства', 1),
('Ноутбуки', 'laptops', 'Ноутбуки и персональные компьютеры', 2),
('Телевизоры', 'tv', 'Телевизоры и мультимедиа', 3),
('Бытовая техника', 'appliances', 'Крупная и мелкая бытовая техника', 4),
('Фото и видео', 'photo-video', 'Фото- и видеотехника', 5);


INSERT INTO manufacturers (name, country, website, founded_year) VALUES
('Apple', 'USA', 'https://apple.com', 1976),
('Samsung', 'South Korea', 'https://samsung.com', 1938),
('Xiaomi', 'China', 'https://mi.com', 2010),
('Lenovo', 'China', 'https://lenovo.com', 1984),
('Sony', 'Japan', 'https://sony.com', 1946),
('LG', 'South Korea', 'https://lg.com', 1947),
('Bosch', 'Germany', 'https://bosch.com', 1886);


INSERT INTO products
(sku, name, category_id, manufacturer_id, base_price, current_price, stock_quantity, short_description, published_at)
VALUES
('IPHONE-15', 'iPhone 15', 1, 1, 89999, 84999, 10, 'Apple iPhone 15 smartphone', CURRENT_TIMESTAMP),
('SAMSUNG-S24', 'Samsung Galaxy S24', 1, 2, 79999, 74999, 15, 'Samsung Galaxy S24 flagship', CURRENT_TIMESTAMP),
('XIAOMI-14', 'Xiaomi 14', 1, 3, 59999, 54999, 20, 'Xiaomi 14 with Leica camera', CURRENT_TIMESTAMP),

('MACBOOK-AIR-M2', 'MacBook Air M2', 2, 1, 129999, 124999, 5, 'Apple MacBook Air with M2 chip', CURRENT_TIMESTAMP),
('LENOVO-IDEAPAD-5', 'Lenovo IdeaPad 5', 2, 4, 69999, 64999, 8, 'Lenovo IdeaPad 5 notebook', CURRENT_TIMESTAMP),

('LG-OLED-55', 'LG OLED 55"', 3, 6, 89999, 84999, 3, 'LG OLED TV 55 inch', CURRENT_TIMESTAMP),
('SONY-BRAVIA-65', 'Sony Bravia 65"', 3, 5, 119999, 114999, 2, 'Sony Bravia TV 65 inch', CURRENT_TIMESTAMP),

('BOSCH-FRIDGE-2C', 'Bosch Refrigerator', 4, 7, 79999, 74999, 4, 'Bosch two-door refrigerator', CURRENT_TIMESTAMP);


INSERT INTO customers (full_name, email, phone, billing_address) VALUES
('Иванов Иван Иванович', 'ivanov@example.com', '+79161234567',
 '{"city":"Москва","street":"Тверская","building":"15","apartment":"42","postal_code":"125009"}'),
('Петрова Мария Сергеевна', 'petrova@example.com', '+79167654321',
 '{"city":"Санкт-Петербург","street":"Невский проспект","building":"28","apartment":"17","postal_code":"191186"}'),
('Сидоров Алексей Владимирович', 'sidorov@example.com', '+79031112233',
 '{"city":"Екатеринбург","street":"Ленина","building":"50","apartment":"23","postal_code":"620014"}'),
('Козлова Анна Дмитриевна', 'kozlova@example.com', '+79205556677',
 '{"city":"Казань","street":"Баумана","building":"12","apartment":"8","postal_code":"420111"}');


INSERT INTO employees
(username, password_hash, full_name, email, role, department, hire_date)
VALUES
('admin', 'hash_admin', 'Смирнов Андрей Викторович', 'admin@store.com', 'admin', 'Administration', '2023-01-15'),
('manager1', 'hash_manager', 'Волкова Ольга Игоревна', 'manager@store.com', 'manager', 'Sales', '2023-03-20'),
('warehouse1', 'hash_warehouse', 'Кузнецов Сергей Александрович', 'warehouse@store.com', 'warehouse', 'Warehouse', '2023-02-10');


INSERT INTO orders
(customer_id, employee_id, status, payment_status,
 subtotal_amount, discount_amount, tax_amount, shipping_amount,
 total_amount, payment_method)
VALUES
(1, 2, 'delivered', 'paid', 84999, 0, 0, 500, 85499, 'card_online'),
(2, 2, 'shipped', 'paid', 124999, 0, 0, 500, 125499, 'card_online'),
(3, 2, 'processing', 'pending', 129998, 0, 0, 1000, 130998, NULL),
(4, 2, 'paid', 'paid', 84999, 0, 0, 0, 84999, 'card_upon_receipt');


INSERT INTO order_items
(order_id, product_id, quantity, unit_price, product_name_at_time)
VALUES
(1, 1, 1, 84999, 'iPhone 15'),
(2, 4, 1, 124999, 'MacBook Air M2'),
(3, 2, 1, 74999, 'Samsung Galaxy S24'),
(3, 3, 1, 54999, 'Xiaomi 14'),
(4, 6, 1, 84999, 'LG OLED 55"');


INSERT INTO deliveries
(order_id, delivery_address, recipient_name, recipient_phone,
 delivery_method, delivery_cost, status)
VALUES
(1, '{"city":"Москва","street":"Тверская","building":"15","apartment":"42"}',
 'Иванов Иван Иванович', '+79161234567', 'courier', 500, 'delivered'),

(2, '{"city":"Санкт-Петербург","street":"Невский проспект","building":"28","apartment":"17"}',
 'Петрова Мария Сергеевна', '+79167654321', 'post', 500, 'in_transit'),

(4, '{"city":"Казань","street":"Баумана","building":"12","apartment":"8"}',
 'Козлова Анна Дмитриевна', '+79205556677', 'courier', 0, 'pending');


INSERT INTO order_status_history
(order_id, old_status, new_status, changed_by_type, changed_by_name, change_reason)
VALUES
(1, NULL, 'created', 'system', 'system', 'order created'),
(1, 'created', 'paid', 'customer', 'Иванов И.И.', 'online payment'),
(1, 'paid', 'shipped', 'employee', 'Волкова О.И.', 'handed to courier'),
(1, 'shipped', 'delivered', 'employee', 'courier', 'delivered'),

(2, NULL, 'created', 'system', 'system', 'order created'),
(2, 'created', 'paid', 'customer', 'Петрова М.С.', 'online payment'),
(2, 'paid', 'shipped', 'employee', 'Волкова О.И.', 'sent by post'),

(3, NULL, 'created', 'system', 'system', 'order created'),

(4, NULL, 'created', 'system', 'system', 'order created'),
(4, 'created', 'paid', 'customer', 'Козлова А.Д.', 'payment on delivery');


INSERT INTO reviews
(product_id, customer_id, order_id, rating, title, comment, status, is_verified_purchase)
VALUES
(1, 1, 1, 5, 'Отличный телефон', 'Качество и камера на высоте.', 'approved', TRUE),
(4, 2, 2, 4, 'Хороший ноутбук', 'Быстрый, но мало портов.', 'approved', TRUE),
(2, 3, 3, 5, 'Отличное соотношение цены и качества', 'Полностью доволен.', 'pending', TRUE);


INSERT INTO promo_codes
(code, description, discount_type, discount_value, min_order_amount, valid_from, valid_until)
VALUES
('WELCOME10', '10% discount for new customers', 'percentage', 10, 5000, CURRENT_TIMESTAMP, '2026-12-31'),
('SUMMER2025', 'Seasonal discount', 'fixed_amount', 5000, 30000, CURRENT_TIMESTAMP, '2026-08-31'),
('FREESHIP', 'Free shipping', 'free_shipping', 0, 20000, CURRENT_TIMESTAMP, '2026-12-31');


COMMIT;
