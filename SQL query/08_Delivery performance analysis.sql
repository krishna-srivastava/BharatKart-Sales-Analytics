USE bharatkart;

SELECT * FROM customers LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM returnss LIMIT 5;

-- H). Delivery Performance Analysis:
-- 1). Overall Delivery Time Metrics (Average, Min, Max Days & Average Delay):
SELECT
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(MIN(delivery_days), 2) AS min_delivery_days,
    ROUND(MAX(delivery_days), 2) AS max_delivery_days,
    ROUND(AVG(delivery_delay), 2) AS avg_delivery_delay
FROM orders
WHERE order_status IN ('Delivered', 'Returned');

-- 2). Delivery Performance Breakdown (Late, On-Time, Early Distribution):
SELECT
    CASE
        WHEN delivery_delay > 0 THEN 'Late'
        WHEN delivery_delay = 0 THEN 'On-time'
        ELSE 'Early'
    END AS delivery_performance,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_share
FROM orders
WHERE order_status IN ('Delivered', 'Returned')
GROUP BY delivery_performance
ORDER BY total_orders DESC;

-- 3). Order Distribution Across Delivery Time Buckets:
SELECT
	CASE
		WHEN delivery_days <= 2 THEN '0-2 days'
        WHEN delivery_days <= 5 THEN '3-5 days'
        WHEN delivery_days <= 8 THEN '6-8 days'
        ELSE '9+ days'
    END AS delivery_bucket,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status IN ('Delivered', 'Returned')
GROUP BY delivery_bucket
ORDER BY MIN(delivery_days);

-- 4). Geographic Analysis: Delivery Speed & Delay Rates by State:
SELECT
    delivery_state,
    COUNT(*) AS total_orders,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(delivery_delay), 2) AS avg_delay,
    ROUND(SUM(CASE WHEN delivery_delay > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM orders
WHERE order_status IN ('Delivered', 'Returned')
GROUP BY delivery_state
ORDER BY late_pct DESC;

-- 5). Top 10 Destination Cities by Order Volume & Delivery Reliability:
SELECT
    delivery_city,
    COUNT(*) AS total_orders,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(SUM(CASE WHEN delivery_delay > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM orders
WHERE order_status IN ('Delivered', 'Returned')
GROUP BY delivery_city
ORDER BY total_orders DESC
LIMIT 10;

-- 6). Impact of Delivery Delays on Product Return Rates
SELECT
    CASE WHEN o.delivery_delay > 0 THEN 'Late' ELSE 'On-time/Early' END AS delivery_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT r.order_id) AS returned_orders,
    ROUND(COUNT(DISTINCT r.order_id) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS return_rate_pct
FROM orders o
LEFT JOIN returnss r ON r.order_id = o.order_id
WHERE o.order_status IN ('Delivered', 'Returned')
GROUP BY delivery_status;

-- 7). Monthly Delivery Delay Trends & Late Order Percentage:
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    ROUND(AVG(delivery_delay), 2) AS avg_delay,
    ROUND(SUM(CASE WHEN delivery_delay > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM orders
WHERE delivery_delay IS NOT NULL
GROUP BY order_month
ORDER BY order_month;