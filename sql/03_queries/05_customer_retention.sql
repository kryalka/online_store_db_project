WITH customer_monthly_stats AS (
    SELECT 
        c.customer_id,
        c.full_name,
        DATE_TRUNC('month', o.created_at) AS order_month,
        COUNT(DISTINCT o.order_id) AS monthly_orders,
        SUM(o.total_amount) AS monthly_spent,
        MIN(o.created_at) AS first_order_in_month,
        MAX(o.created_at) AS last_order_in_month
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
        AND o.payment_status = 'paid'
    GROUP BY c.customer_id, c.full_name, DATE_TRUNC('month', o.created_at)
),
customer_retention AS (
    SELECT 
        customer_id,
        full_name,
        order_month,
        monthly_orders,
        monthly_spent,
        first_order_in_month,
        last_order_in_month,
        LAG(order_month) OVER (PARTITION BY customer_id ORDER BY order_month) AS prev_order_month,
        LAG(monthly_spent) OVER (PARTITION BY customer_id ORDER BY order_month) AS prev_month_spent,
        CASE 
            WHEN LAG(order_month) OVER (PARTITION BY customer_id ORDER BY order_month) IS NULL 
            THEN 'Новый'
            WHEN EXTRACT(MONTH FROM AGE(order_month, LAG(order_month) OVER (PARTITION BY customer_id ORDER BY order_month))) = 1
            THEN 'Удержанный'
            ELSE 'Вернувшийся'
        END AS retention_status,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_month) AS customer_order_month_num
    FROM customer_monthly_stats
)
SELECT 
    order_month,
    retention_status,
    COUNT(DISTINCT customer_id) AS customers_count,
    SUM(monthly_orders) AS total_orders,
    SUM(monthly_spent) AS total_revenue,
    ROUND(AVG(monthly_spent), 2) AS avg_customer_spent,
    ROUND(100.0 * COUNT(DISTINCT customer_id) / 
        LAG(COUNT(DISTINCT customer_id)) OVER (ORDER BY order_month), 2) AS retention_rate_percent
FROM customer_retention
WHERE order_month IS NOT NULL
GROUP BY order_month, retention_status
ORDER BY order_month DESC, retention_status;