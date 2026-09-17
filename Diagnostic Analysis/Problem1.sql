USE bharatkart;

-- DIAGNOSTIC ANALYSIS: PROBLEM 1 — PROFITABILITY CRISIS
-- Goal: Uncover why ₹87+ Cr revenue yields only 2.38% overall profit margin.

-- Query 1.1: Overall Profitability & Discount-Margin Conflict Split:
SELECT
	CASE WHEN oi.profit > 0 THEN "Profitable" ELSE "Loss-making" END AS item_group,
	COUNT(*) AS total_items,
	ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(AVG(oi.unit_price), 2) AS avg_unit_price,
    ROUND(AVG(oi.cost_price), 2) AS avg_cost_price,
    ROUND(AVG((oi.unit_price - oi.cost_price) / oi.cost_price * 100), 2) AS avg_base_margin_pct  
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = "Delivered"
GROUP BY item_group;

-- Query 1.2: Category-Level Revenue, Margin, and Loss Concentration:
SELECT
    p.category,  
    COUNT(*) AS total_items,
    SUM(CASE WHEN oi.profit > 0 THEN 1 ELSE 0 END) AS profit_items,
    SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_items,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(SUM(CASE WHEN oi.profit < 0 THEN profit ELSE 0 END), 2) AS total_loss,
    ROUND(SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS loss_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category;

-- Query 1.3a: Deep-Dive Margin vs Discount Gap (Electronics & Grocery):
SELECT
    p.category,
    CASE WHEN oi.profit < 0 THEN 'Loss-Making' ELSE 'Profitable' END AS item_group,
    COUNT(*) AS total_items,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(AVG((oi.unit_price - oi.cost_price) / oi.cost_price * 100), 2) AS avg_base_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
  AND p.category IN ('Electronics', 'Grocery')
GROUP BY p.category, item_group
ORDER BY p.category, item_group;

-- Query 1.3b: Deep-Dive Margin vs Discount Gap (Remaining Categories)
SELECT
    p.category,
    CASE WHEN oi.profit < 0 THEN 'Loss-Making' ELSE 'Profitable' END AS item_group,
    COUNT(*) AS total_items,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(AVG((oi.unit_price - oi.cost_price) / oi.cost_price * 100), 2) AS avg_base_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
  AND p.category NOT IN ('Electronics', 'Grocery')
GROUP BY p.category, item_group
ORDER BY p.category, item_group;

-- Query 1.4: Sub-Category Profitability Leakage (Electronics & Grocery):
SELECT
	p.category, p.sub_category,
    COUNT(oi.order_item_id) AS items_sold,
    SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_items_count,
    ROUND(SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(oi.order_item_id), 2) AS loss_item_pct,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(SUM(oi.item_total), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = "Delivered" AND p.category IN ("Electronics", "Grocery")
GROUP BY p.category, p.sub_category
ORDER BY p.category, p.sub_category;

-- Query 1.5: Top 10 Outlier Loss-Making Products (SKU Concentration):
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(AVG((oi.unit_price - oi.cost_price) / oi.cost_price * 100), 2) AS avg_base_margin_pct,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_loss
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
  AND oi.profit < 0
GROUP BY p.product_id, p.product_name, p.category, p.sub_category
ORDER BY total_loss ASC
LIMIT 10;

-- Query 1.6: Seller Tier Loss Breakdown (Electronics & Grocery):
SELECT 
    s.seller_tier,
    p.category,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = 'Delivered'
  AND p.category IN ('Electronics', 'Grocery')
GROUP BY s.seller_tier, p.category
ORDER BY p.category, total_profit ASC;