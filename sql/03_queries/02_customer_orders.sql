WITH customer_order_stats AS (
    SELECT 
        c.customer_id,
        c.full_name,
        c.email,
        c.phone,
        c.registration_date,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT CASE 
            WHEN o.payment_status = 'paid' 
            THEN o.order_id 
        END) AS paid_orders,
        COUNT(DISTINCT CASE 
            WHEN o.payment_status = 'pending' 
            THEN o.order_id 
        END) AS pending_orders,
        SUM(CASE 
            WHEN o.payment_status = 'paid' 
            THEN o.total_amount 
            ELSE 0 
        END) AS total_spent,
        MIN(o.created_at) AS first_order_date,
        MAX(o.created_at) AS last_order_date,
        AVG(o.total_amount) AS avg_order_value
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.full_name, c.email, c.phone, c.registration_date
),
customer_segments AS (
    SELECT 
        customer_id,
        full_name,
        email,
        phone,
        registration_date,
        total_orders,
        paid_orders,
        pending_orders,
        total_spent,
        first_order_date,
        last_order_date,
        avg_order_value,
        CASE 
            WHEN total_spent >= 100000 THEN 'VIP'
            WHEN total_spent >= 50000 THEN 'Постоянный'
            WHEN total_spent > 0 THEN 'Новый'
            ELSE 'Потенциальный'
        END AS customer_segment,
        CASE 
            WHEN last_order_date IS NULL THEN 'Нет заказов'
            WHEN last_order_date >= CURRENT_DATE - INTERVAL '30 days' THEN 'Активный'
            WHEN last_order_date >= CURRENT_DATE - INTERVAL '90 days' THEN 'Умеренный'
            WHEN last_order_date >= CURRENT_DATE - INTERVAL '180 days' THEN 'Пассивный'
            ELSE 'Неактивный'
        END AS activity_status
    FROM customer_order_stats
)
SELECT 
    customer_id,
    full_name,
    email,
    phone,
    registration_date,
    customer_segment,
    activity_status,
    total_orders,
    paid_orders,
    pending_orders,
    total_spent,
    first_order_date,
    last_order_date,
    COALESCE(last_order_date, registration_date) AS last_activity_date,
    avg_order_value,
    COALESCE(EXTRACT(DAY FROM CURRENT_TIMESTAMP - last_order_date), 
             EXTRACT(DAY FROM CURRENT_TIMESTAMP - registration_date)) AS days_since_last_activity
FROM customer_segments
WHERE customer_segment != 'Потенциальный'
ORDER BY total_spent DESC
LIMIT 20;