USE bharatkart;

-- PROBLEM 5 - SELLER LOSS LEAKAGE IN MAHARASHTRA & TAMIL NADU
-- Main Question: Identify root causes driving negative profit margins in Maharashtra 
--            & Tamil Nadu, and analyze loss-making sellers across Seller Tiers.

-- Query 5.1: Top Loss-Making Outlier Sellers in MH & TN:
SELECT 
    s.seller_state, 
    s.seller_id,
    s.seller_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_items,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
	ROUND(SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(oi.order_item_id), 2) AS loss_item_share_pc
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
  AND s.seller_state IN ('Maharashtra', 'Tamil Nadu')
GROUP BY s.seller_state, s.seller_id, s.seller_name
ORDER BY net_profit ASC
LIMIT 20;

-- Query 5.2: Category Mix & Profitability in MH & TN:
SELECT 
    s.seller_state,
    p.category,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
  AND s.seller_state IN ('Maharashtra', 'Tamil Nadu')
GROUP BY s.seller_state, p.category
ORDER BY s.seller_state, net_profit ASC;

-- Query 5.3: Festive Sale Impact (October Deep Discounts vs Rest of Year):
SELECT 
    s.seller_state,
    CASE WHEN MONTH(o.order_date) = 10 THEN 'October (Festive)' ELSE 'Rest of Year' END AS period_group,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
  AND s.seller_state IN ('Maharashtra', 'Tamil Nadu')
GROUP BY s.seller_state, period_group
ORDER BY s.seller_state, period_group;

-- Query 5.4: Seller Tier Profitability & Loss-Making Sellers Count:
SELECT 
    seller_tier,
    COUNT(seller_id) AS total_sellers,
    SUM(CASE WHEN net_profit < 0 THEN 1 ELSE 0 END) AS loss_making_sellers,
    ROUND(SUM(CASE WHEN net_profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(seller_id), 2) AS loss_seller_pct,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(net_profit), 2) AS net_profit,
    ROUND(SUM(net_profit) * 100.0 / SUM(total_revenue), 2) AS profit_margin_pct,
    ROUND(AVG(avg_discount_pct), 2) AS avg_discount_pct,
    ROUND(SUM(loss_items) * 100.0 / SUM(total_items), 2) AS loss_item_pct
FROM (
    SELECT 
        s.seller_id,
        s.seller_tier,
        COUNT(oi.order_item_id) AS total_items,
        SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_items,
        SUM(oi.item_total) AS total_revenue,
        SUM(oi.profit) AS net_profit,
        AVG(oi.discount_percent) AS avg_discount_pct
    FROM sellers s
    JOIN order_items oi ON s.seller_id = oi.seller_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY s.seller_id, s.seller_tier
) AS seller_summary
GROUP BY seller_tier
ORDER BY profit_margin_pct DESC;

-- Query 5.5: Category Revenue & Profit Breakdown across Seller Tiers:
SELECT 
    s.seller_tier,
    p.category,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY s.seller_tier, p.category
ORDER BY s.seller_tier, net_profit ASC;