WITH product_sales AS (
    SELECT 
        p.product_id,
        p.name,
        p.sku,
        m.name AS manufacturer_name,
        c.name AS category_name,
        p.current_price,
        p.average_rating,
        p.review_count,
        SUM(oi.quantity) AS total_quantity_sold,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
    JOIN categories c ON p.category_id = c.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.payment_status = 'paid'
        AND o.created_at >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY p.product_id, p.name, p.sku, m.name, c.name, p.current_price, p.average_rating, p.review_count
),
ranked_products AS (
    SELECT 
        product_id,
        name AS product_name,
        sku,
        manufacturer_name,
        category_name,
        current_price,
        average_rating,
        review_count,
        total_quantity_sold,
        total_revenue,
        RANK() OVER (ORDER BY total_quantity_sold DESC) AS rank_by_quantity,
        RANK() OVER (ORDER BY total_revenue DESC) AS rank_by_revenue,
        ROUND(total_revenue / NULLIF(total_quantity_sold, 0), 2) AS avg_price_per_unit
    FROM product_sales
)
SELECT 
    rank_by_quantity AS sales_rank,
    product_name,
    sku,
    manufacturer_name,
    category_name,
    current_price,
    total_quantity_sold,
    total_revenue,
    avg_price_per_unit,
    average_rating,
    review_count
FROM ranked_products
ORDER BY rank_by_quantity
LIMIT 10;