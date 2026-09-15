USE bharatkart;

SELECT * FROM customers LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM returnss LIMIT 5;

-- A). Business Overview:
-- 1). Total Entity Volume Counts (Customers, Products, Sellers, Returns):
SELECT
	(SELECT COUNT(*) FROM customers) AS Total_Customers,
	(SELECT COUNT(*) FROM products) AS Total_Products,
    (SELECT COUNT(*) FROM sellers) AS Total_Sellers,
    (SELECT COUNT(*) FROM returnss) AS Total_Returns;

-- 2). Total Orders, Order Items & Multiplier Ratio (Items Per Order):
SELECT
	(SELECT COUNT(*) FROM orders) AS Total_Orders,
    (SELECT COUNT(*) FROM order_items) AS Total_Order_Items,
	CONCAT(ROUND((SELECT COUNT(*) FROM order_items) * 1.0 / (SELECT COUNT(*) FROM orders), 2), 'x') AS ratio_multiplier;

-- 3). Business Operating Timeline (First & Last Order Date):
SELECT MIN(order_date) AS First_order, MAX(order_date) AS Last_Order 
FROM orders;

-- 4). Order Status Volume & Percentage Share (%) Breakdown:
SELECT 
	order_status,
    COUNT(*) AS Total_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders) , 2) AS Status_Percentage
FROM orders
GROUP BY order_status
ORDER BY Total_Orders DESC;

-- 5). Gross Monetary Revenue Split by Order Status:
SELECT
	ROUND(SUM(order_total), 2) AS gross_completed_revenue,
    ROUND(SUM(CASE WHEN order_status IN ('Delivered') THEN order_total ELSE 0 END), 2) AS delivered_only_revenue,
    ROUND(SUM(CASE WHEN order_status IN ('Returned') THEN order_total ELSE 0 END), 2) AS returned_order_value,
    ROUND(SUM(CASE WHEN order_status IN ('Cancelled') THEN order_total ELSE 0 END), 2) AS Cancelled_order_value,
    ROUND(SUM(CASE WHEN order_status IN ('Shipped') THEN order_total ELSE 0 END), 2) AS Shipped_order_value,
    ROUND(SUM(CASE WHEN order_status IN ('Pending') THEN order_total ELSE 0 END), 2) AS Pending_order_value
FROM orders;

-- 6). Delivered Orders - Revenue Stats & Average Order Value (AOV):
SELECT 
	ROUND(SUM(order_total),2) AS total_revenue,
    ROUND(AVG(order_total),2) AS avg_order_value,
    ROUND(MAX(order_total),2) AS max_order_value,
    ROUND(MIN(order_total),2) AS min_order_value
FROM orders
WHERE order_status = "Delivered";

-- 7). Delivered Orders - Line Item Revenue, Net Profit & Profit Margin %:
SELECT
    ROUND(SUM(oi.item_total), 2) AS Total_Revenue_Delivered,
    ROUND(SUM(oi.profit), 2) AS Net_Profit_Delivered,
    CONCAT(ROUND(SUM(oi.profit) * 100.0 / SUM(oi.item_total), 2), '%') AS Profit_Margin_Pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered';

-- 8). Line Item Profitability Deep Dive (Profitable vs Loss-Making Items):
SELECT 
	ROUND(SUM(profit), 2) AS Net_profit,
    COUNT(CASE WHEN profit > 0 THEN 1 END) AS Profitable_line_items,
    ROUND(SUM(CASE WHEN profit > 0 THEN profit ELSE 0 END), 2) AS Total_gross_profit,
    ROUND(SUM(CASE WHEN profit > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS profit_pct,
    
    COUNT(CASE WHEN profit < 0 THEN 1 END) AS Loss_line_items,
    ROUND(SUM(CASE WHEN profit < 0 THEN profit ELSE 0 END), 2) AS Total_loss,
    ROUND(SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS loss_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = "Delivered";

