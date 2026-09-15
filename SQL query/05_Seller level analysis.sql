USE bharatkart;

SELECT * FROM customers LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM returnss LIMIT 5;

-- E). Seller Level Analysis:
-- 1). Seller Distribution & Average Rating by Seller Tier:
SELECT
    seller_tier,
    COUNT(*) AS total_sellers,
    ROUND(AVG(seller_rating), 2) AS avg_rating
FROM sellers
GROUP BY seller_tier;

-- 2). Financial Performance & Average Revenue per Seller by Seller Tier:
SELECT
    seller_tier,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(SUM(oi.item_total) / COUNT(DISTINCT s.seller_id), 2) AS avg_revenue_per_seller
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = "Delivered"
GROUP BY s.seller_tier;

-- 3). Top 10 High-Performing Sellers by Total Revenue:
SELECT
	s.seller_id, s.seller_name, s.seller_tier, s.seller_rating, s.seller_city, s.seller_state,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = "Delivered"
GROUP BY s.seller_id, s.seller_name, s.seller_tier, s.seller_rating, s.seller_city, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- 4). Bottom 10 Lowest Performing Sellers by Total Revenue:
SELECT
	s.seller_id, s.seller_name, s.seller_tier, s.seller_rating, s.seller_city, s.seller_state,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = "Delivered"
GROUP BY s.seller_id, s.seller_name, s.seller_tier, s.seller_rating, s.seller_city, s.seller_state
ORDER BY total_revenue
LIMIT 10;

-- 5). Seller Performance Breakdown by Rating Buckets (FLOOR Rating):
SELECT
    FLOOR(s.seller_rating) AS rating_bucket,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
	 ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(AVG(oi.item_total), 2) AS avg_item_value
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = 'Delivered'
GROUP BY rating_bucket
ORDER BY rating_bucket;

-- 6). Geographic Analysis: State-Wise Seller Revenue Contribution:
SELECT
    s.seller_state,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
	ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = 'Delivered'
GROUP BY s.seller_state
ORDER BY total_revenue DESC;

-- 7). Geographic Analysis: State-Wise Seller Profitability:
SELECT
    s.seller_state,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
	ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = 'Delivered'
GROUP BY s.seller_state
ORDER BY total_profit DESC;

-- 8). Primary Category Analysis: Seller Revenue & Profit Contribution:
SELECT
    s.primary_category,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = 'Delivered'
GROUP BY s.primary_category
ORDER BY total_revenue DESC;