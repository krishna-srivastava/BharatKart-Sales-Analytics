USE bharatkart;

SELECT * FROM customers LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM returnss LIMIT 5;

-- B). Time-based Trend:
-- 1). Yearly Business Performance & Growth Trend:
SELECT 
	YEAR(o.order_date) AS order_year,
	COUNT(DISTINCT(o.order_id)) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(AVG(oi.item_total), 2) AS avg_item_value
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = "Delivered"
GROUP BY order_year
ORDER BY order_year;

-- 2). Aggregate Quarterly Performance & Seasonality (Q1 to Q4 Breakdown):
SELECT 
    CONCAT('Q', QUARTER(o.order_date)) AS quarter,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY CONCAT('Q', QUARTER(o.order_date))
ORDER BY quarter;

-- 3). Month-of-Year Seasonality Analysis (Aggregated Monthly Metrics):
SELECT
    MONTH(o.order_date) AS month_num,
    MONTHNAME(o.order_date) AS month_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY month_num, month_name
ORDER BY month_num;

-- 4). Chronological Monthly Time-Series Trend (Year-Month Level):
SELECT 
	DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
	COUNT(DISTINCT(o.order_id)) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = "Delivered"
GROUP BY order_month
ORDER BY order_month;

-- 5). Top 5 Most Profitable Months (Peak Operating Performance):
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY order_month
ORDER BY total_profit DESC
LIMIT 5;

-- 6). Bottom 5 Least Profitable Months (Low-Performance Operating Period):
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY order_month
ORDER BY total_profit
LIMIT 5;

-- 7). Day-of-Week Sales Performance & Weekly Buying Patterns (Mon to Sun):
SELECT
    DAYNAME(o.order_date) AS day_of_week,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(AVG(oi.item_total), 2) AS avg_order_value
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');