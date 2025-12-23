SELECT 
    p.product_id,
    p.name,
    p.sku,
    m.name AS manufacturer,
    p.current_price,
    p.stock_quantity,
    p.average_rating,
    (
        SELECT COUNT(DISTINCT o.customer_id)
        FROM order_items oi
        JOIN orders o ON oi.order_id = o.order_id
        WHERE oi.product_id = p.product_id
          AND o.payment_status = 'paid'
    ) AS unique_customers,
    (
        SELECT STRING_AGG(DISTINCT c.full_name, ', ')
        FROM order_items oi
        JOIN orders o ON oi.order_id = o.order_id
        JOIN customers c ON o.customer_id = c.customer_id
        WHERE oi.product_id = p.product_id
          AND o.payment_status = 'paid'
        LIMIT 3
    ) AS recent_customers
FROM products p
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
WHERE EXISTS (
    SELECT 1
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE oi.product_id = p.product_id
      AND o.payment_status = 'paid'
      AND o.created_at >= CURRENT_DATE - INTERVAL '90 days'
)
AND p.is_active = TRUE
ORDER BY (
    SELECT COALESCE(SUM(oi.quantity), 0)
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE oi.product_id = p.product_id
      AND o.payment_status = 'paid'
      AND o.created_at >= CURRENT_DATE - INTERVAL '30 days'
) DESC;