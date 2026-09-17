USE bharatkart;

-- DIAGNOSTIC ANALYSIS: PROBLEM 2 — Q4/October Profit Collapse
-- Goal: Why does revenue peak in Q4/October while profitability collapses?

-- Query 2.1: Yearly Unit Economics Split (Profitable vs Loss-Making Items):
SELECT
	DATE_FORMAT(o.order_date, '%Y') AS year_,
	CASE WHEN oi.profit > 0 THEN "Profitable" ELSE "Loss-making" END AS item_group,
	COUNT(oi.order_item_id) AS items_sold,
	ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(AVG((oi.unit_price - oi.cost_price) / oi.cost_price * 100), 2) AS avg_base_margin_pct,
    ROUND(AVG(oi.unit_price), 2) AS avg_unit_price,
    ROUND(AVG(oi.cost_price), 2) AS avg_cost_price
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = "Delivered"
GROUP BY year_,item_group;

-- Query 2.2: Monthly Trend Analysis (Revenue, Profitability & Discount Spikes):
SELECT
    MONTH(o.order_date) AS y_month,
    COUNT(oi.order_item_id) AS items_sold,
	SUM(CASE WHEN oi.profit > 0 THEN 1 ELSE 0 END) AS profit_items,
    SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_items,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(AVG((oi.unit_price - oi.cost_price) / oi.cost_price * 100), 2) AS avg_base_margin_pct,
    ROUND(SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(oi.order_item_id), 2) AS loss_item_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY y_month
ORDER BY y_month;

-- Query 2.3: Category Margin Breakdown (October Festive vs Rest of Year):
SELECT
    p.category,
    CASE WHEN MONTH(o.order_date) = 10 THEN 'October (Festive)' ELSE 'Rest of Year' END AS period_group,
    COUNT(oi.order_item_id) AS items_sold,
	SUM(CASE WHEN oi.profit > 0 THEN 1 ELSE 0 END) AS profit_items,
    SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_items,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category, period_group
ORDER BY p.category, period_group;

-- Query 2.4: Year-over-Year October Scaling Failure (2024 vs 2025):
SELECT
    YEAR(o.order_date) AS order_year,
    COUNT(oi.order_item_id) AS items_sold,
    SUM(CASE WHEN oi.profit > 0 THEN 1 ELSE 0 END) AS profit_items,
    SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_items,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS net_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    ROUND(SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(oi.order_item_id), 2) AS loss_item_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
  AND MONTH(o.order_date) = 10
GROUP BY YEAR(o.order_date)
ORDER BY order_year ASC;