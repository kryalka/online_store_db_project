WITH daily_sales AS (
    SELECT 
        DATE(o.created_at) AS sale_date,
        p.category_id,
        c.name AS category_name,
        COUNT(DISTINCT o.order_id) AS orders_count,
        SUM(oi.quantity) AS items_sold,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        AVG(o.total_amount) AS avg_order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    WHERE o.payment_status = 'paid'
    GROUP BY DATE(o.created_at), p.category_id, c.name
)
SELECT 
    sale_date,
    category_name,
    orders_count,
    items_sold,
    revenue,
    avg_order_value,
    SUM(revenue) OVER (PARTITION BY category_name ORDER BY sale_date) AS cumulative_revenue,
    ROUND(100.0 * revenue / SUM(revenue) OVER (PARTITION BY sale_date), 2) AS daily_category_percentage
FROM daily_sales
ORDER BY sale_date DESC, revenue DESC;