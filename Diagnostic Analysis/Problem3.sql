USE bharatkart;

-- Problem 3 — Customer Behaviour
-- Main Question: Why are most customers not becoming repeat customers, and why do VIP customers have the lowest margin?

-- Query 3.1: Customer Order Bucket Analysis:
SELECT 
    CASE 
        WHEN order_count = 1 THEN '1 Order (One-Time)'
        WHEN order_count = 2 THEN '2 Orders'
        WHEN order_count BETWEEN 3 AND 5 THEN '3-5 Orders'
        ELSE '6+'
    END AS customer_bucket,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(total_profit), 2) AS total_profit,
    ROUND(SUM(total_profit) * 100.0 / SUM(total_revenue), 2) AS profit_margin_pct,
    ROUND(AVG(avg_discount), 2) AS avg_discount_pct
FROM (
    SELECT 
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(oi.item_total) AS total_revenue,
        SUM(oi.profit) AS total_profit,
        AVG(oi.discount_percent) AS avg_discount
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
) AS customer_summary
GROUP BY customer_bucket
ORDER BY total_customers DESC;

-- Query 3.2: CUSTOMER SEGMENT FINANCIAL PERFORMANCE & LOSS EXPOSURE:
SELECT
	o.customer_segment,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(oi.order_item_id), 2) AS loss_item_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.customer_segment;

-- Query 3.3: CATEGORY SPLIT BY CUSTOMER SEGMENT (SMOKING GUN FOR VIP MARGIN COLLAPSE):
SELECT 
    o.customer_segment,
    p.category,
    COUNT(oi.order_item_id) AS items_purchased,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY o.customer_segment, p.category
ORDER BY p.category ASC;

-- Query 3.4: ENTRY CATEGORY RETENTION CONVERSION:
WITH first_orders AS (
    SELECT 
        o.customer_id,
        o.order_id,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date ASC) AS order_seq
    FROM orders o
),
customer_lifetime AS (
    SELECT customer_id, COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT 
    p.category AS entry_category,
    COUNT(DISTINCT fo.customer_id) AS total_entry_customers,
    COUNT(DISTINCT CASE WHEN cl.total_orders > 1 THEN fo.customer_id END) AS repeat_customers,
    ROUND(COUNT(DISTINCT CASE WHEN cl.total_orders > 1 THEN fo.customer_id END) * 100.0 / COUNT(DISTINCT fo.customer_id), 2) AS repeat_rate_pct
FROM first_orders fo
JOIN order_items oi ON fo.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN customer_lifetime cl ON fo.customer_id = cl.customer_id
WHERE fo.order_seq = 1
GROUP BY p.category
ORDER BY total_entry_customers DESC;

-- Query 3.5: FESTIVE SEASON ACQUISITION COHORT CHURN (OCTOBER FESTIVE SURGE):
SELECT
    CASE WHEN MONTH(first_order_date) = 10 THEN 'Acquired in October' ELSE 'Acquired Other Months' END AS acquisition_group,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    ROUND(SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS one_time_pct
FROM (
    SELECT o.customer_id, MIN(o.order_date) AS first_order_date, COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
) t
GROUP BY acquisition_group;

-- Query 3.5: POST-PURCHASE EXPERIENCE CHECK (RETURN STATUS IMPACT):
SELECT
    CASE WHEN r.order_id IS NOT NULL THEN 'Had a Return' ELSE 'No Return' END AS return_experience,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    ROUND(AVG(customer_orders.total_orders), 2) AS avg_orders_per_customer
FROM orders o
LEFT JOIN returnss r ON r.order_id = o.order_id
JOIN (
    SELECT customer_id, COUNT(DISTINCT order_id) AS total_orders
    FROM orders WHERE order_status = 'Delivered'
    GROUP BY customer_id
) customer_orders ON customer_orders.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY return_experience;