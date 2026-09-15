USE bharatkart;

SELECT * FROM customers LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM returnss LIMIT 5;

-- D). Customer Level Analysis:
-- 1). Customer Volume & Order Count by Customer Segment:
SELECT 
	o.customer_segment,
    COUNT(DISTINCT(o.customer_id)) AS Total_customer,
    COUNT(DISTINCT(o.order_id)) AS Total_order
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = "Delivered"
GROUP BY o.customer_segment;

-- 2). Financial Performance & Revenue Contribution Share by Customer Segment:
SELECT 
	o.customer_segment,
    ROUND(SUM(oi.item_total), 2) AS Total_revenue,
	ROUND(SUM(oi.profit), 2) AS Total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,  
	ROUND(AVG(oi.item_total), 2) AS Avg_item_value,
    ROUND(SUM(oi.item_total) * 100.0 / SUM(SUM(oi.item_total)) OVER(), 2) AS revenue_contribution_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = "Delivered"
GROUP BY o.customer_segment;

-- 3). Top 10 High-Value Customers (Highest Total Spend):
SELECT
	c.customer_id,
    c.customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
	ROUND(SUM(oi.item_total),2) AS total_spend
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = "Delivered"
GROUP BY c.customer_id, c.customer_name, c.city, c.state
ORDER BY total_spend DESC
LIMIT 10;

-- 4). Geographic Analysis: State-Wise Customer Revenue & Order Volume:
SELECT
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
	ROUND(SUM(oi.item_total),2) AS total_revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = "Delivered"
GROUP BY c.state
ORDER BY total_revenue DESC;

-- 5). Geographic Analysis: Top 10 Cities by Total Revenue:
SELECT
	c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
	ROUND(SUM(oi.item_total),2) AS total_revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = "Delivered"
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 10;

-- 6). Customer Demographics: Gender-Wise Revenue & Order Distribution:
SELECT
    c.gender,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(AVG(oi.item_total), 2) AS avg_item_value
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.gender;

-- 7). Customer Order Frequency & Loyalty Distribution (Order Buckets):
SELECT
    order_count_bucket,
    COUNT(*) AS num_customers
FROM (
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        CASE
            WHEN COUNT(*) = 1 THEN '1 order'
            WHEN COUNT(*) BETWEEN 2 AND 3 THEN '2-3 orders'
            WHEN COUNT(*) BETWEEN 4 AND 5 THEN '4-5 orders'
            ELSE '6+ orders' END AS order_count_bucket
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
) t
GROUP BY order_count_bucket
ORDER BY FIELD(order_count_bucket, '1 order','2-3 orders','4-5 orders','6+ orders');

-- 8). Order Return Rate Percentage by Customer Segment:
SELECT
    o.customer_segment,
    COUNT(DISTINCT o.order_id) AS total_delivered_orders,
    COUNT(DISTINCT r.order_id) AS returned_orders,
    ROUND(COUNT(DISTINCT r.order_id) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS return_rate_pct
FROM orders o
LEFT JOIN returnss r ON r.order_id = o.order_id
WHERE o.order_status IN ('Delivered', 'Returned')
GROUP BY o.customer_segment
ORDER BY return_rate_pct DESC;

-- 9). Monthly Customer Acquisition & Signup Velocity:
SELECT
    DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY signup_month
ORDER BY signup_month;