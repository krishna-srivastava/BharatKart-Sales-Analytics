USE bharatkart;

-- PROBLEM 4 — OPERATIONAL PROBLEMS & LATE DELIVERIES
-- Main Question: Pinpoint root causes driving the 61.2% late delivery rate.

-- Query 4.1: Geographic Logistics & Delay Breakdown by State:
SELECT 
    o.delivery_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(CASE WHEN o.delivery_delay > 0 THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN o.delivery_delay > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS late_delivery_pct,
    ROUND(AVG(o.delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(o.delivery_delay), 2) AS avg_delay_days
FROM orders o
WHERE o.order_status = 'Delivered'
GROUP BY o.delivery_state
ORDER BY late_orders DESC;

-- Query 4.2: Seller Fulfillment & Dispatch SLA Audit:
SELECT 
    s.seller_id,
    s.seller_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(CASE WHEN o.delivery_delay > 0 THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN o.delivery_delay > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS late_delivery_pct,
    ROUND(AVG(DATEDIFF(o.shipped_date, o.order_date)), 2) AS avg_dispatch_days,
    ROUND(AVG(o.delivery_delay), 2) AS avg_delay_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = 'Delivered'
GROUP BY s.seller_id, s.seller_name
HAVING total_orders >= 100
ORDER BY late_delivery_pct DESC;

-- Query 4.3: Order-Level Primary Category Breakdown:
WITH order_category_spend AS (
    SELECT 
        oi.order_id,
        p.category,
        SUM(oi.item_total) AS cat_spend,
        ROW_NUMBER() OVER (PARTITION BY oi.order_id ORDER BY SUM(oi.item_total) DESC) AS rn
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY oi.order_id, p.category
),
primary_order_category AS (
    SELECT order_id, category AS primary_category
    FROM order_category_spend
    WHERE rn = 1
)
SELECT 
    poc.primary_category,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.delivery_delay > 0 THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN o.delivery_delay > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.order_id), 2) AS late_delivery_pct,
    ROUND(AVG(o.delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(o.delivery_delay), 2) AS avg_delay_days
FROM orders o
JOIN primary_order_category poc ON o.order_id = poc.order_id
WHERE o.order_status = 'Delivered'
GROUP BY poc.primary_category
ORDER BY late_delivery_pct DESC;

-- Query 4.4: Impact of Late Delivery Performance on Product Returns:
SELECT 
    CASE 
        WHEN o.delivery_delay > 0 THEN 'Late Delivery'
        ELSE 'On-Time / Early Delivery'
    END AS delivery_performance,
    COUNT(DISTINCT o.order_id) AS total_delivered_orders,
    COUNT(DISTINCT r.order_id) AS returned_orders,
    ROUND(COUNT(DISTINCT r.order_id) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS return_rate_pct
FROM orders o
LEFT JOIN returnss r ON r.order_id = o.order_id
WHERE o.order_status IN ('Delivered', 'Returned')  
GROUP BY delivery_performance;