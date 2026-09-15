USE bharatkart;

SELECT * FROM customers LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM returnss LIMIT 5;

-- C). Category/Product Level:
-- 1). Product Catalog Size & Hierarchy (Categories & Sub-Categories Count):
SELECT 
	COUNT(*) AS Total_Products,
	COUNT(DISTINCT(category)) AS Total_category,
    COUNT(DISTINCT(sub_category)) AS Total_subcategory
FROM products;

-- 2). Top 10 Highest Revenue-Generating Products (Delivered Orders):
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
	ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,    
    SUM(oi.quantity) AS total_qty_sold
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;

-- 3). Bottom 10 Lowest Revenue-Generating Products (Delivered Orders)
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
	ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    SUM(oi.quantity) AS total_qty_sold
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue
LIMIT 10;

-- 4). Top 10 Most Profitable Individual Products (Delivered Orders):
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
	ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,    
    SUM(oi.quantity) AS total_qty_sold
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_profit DESC
LIMIT 10;

-- 5). Bottom 10 Most Loss-Making Products (Delivered Orders):
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
	ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,    
    SUM(oi.quantity) AS total_qty_sold
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_profit
LIMIT 10;

-- 6). Category-Wise Performance Overview (Revenue, Profit, Margin % & Quantity Metrics)
SELECT 
    p.category,
    COUNT(*) AS total_items,
    SUM(CASE WHEN oi.profit > 0 THEN 1 ELSE 0 END) AS profit_items,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(AVG(oi.quantity), 2) AS avg_quantity_per_item
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = "Delivered"
GROUP BY p.category;

-- 7). Category-Wise Loss Deep Dive (Loss Items, Total Loss Amount & Loss Share %):
SELECT
    p.category,  
    COUNT(*) AS total_items,
    SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_items,
    ROUND(SUM(CASE WHEN oi.profit < 0 THEN profit ELSE 0 END), 2) AS Total_loss,
    ROUND(SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS loss_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category;

-- 8). Bottom 15 Least Profitable Sub-Categories (Sub-Category Loss Drivers):
SELECT p.category,
	p.sub_category,
	COUNT(*) AS total_items,
    SUM(CASE WHEN oi.profit > 0 THEN 1 ELSE 0 END) AS profit_items,
	ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = "Delivered"
GROUP BY p.category, p.sub_category
ORDER BY total_profit 
LIMIT 15;

-- 9). Category-Wise Discount Percentage vs Profit Margin % Analysis:
SELECT
    p.category,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
    ROUND(MAX(oi.discount_percent), 2) AS max_discount_pct,
    ROUND(MIN(oi.discount_percent), 2) AS min_discount_pct,
    ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY avg_discount_pct DESC;