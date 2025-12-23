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

COMMENT ON FUNCTION get_customer_total_spent IS
'Возвращает суммарную стоимость всех оплаченных заказов клиента';


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

COMMENT ON FUNCTION check_product_availability IS
'Проверяет, достаточно ли доступного товара на складе';



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
