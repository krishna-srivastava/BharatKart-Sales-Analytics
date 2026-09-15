USE bharatkart;

SELECT * FROM customers LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM returnss LIMIT 5;

-- G). Returns/Cancellation Analysis:
-- 1). Return Types Breakdown: Whole Order Returns vs Item-Level Returns:
SELECT 
    (SELECT COUNT(*) FROM returnss) AS total_returns,
    (SELECT COUNT(*) FROM returnss WHERE order_item_id IS NULL) AS Whole_Orders_Returns,
    (SELECT COUNT(*) FROM returnss WHERE order_item_id IS NOT NULL) AS Order_itemsReturn;

-- 2). Financial Impact: Claimed vs Actual Refunded & Saved Amount from Rejections:
SELECT
    ROUND(SUM(return_claim_amount), 2) AS total_claimed,
    ROUND(SUM(actual_refund), 2) AS total_actual_refunded,
    ROUND(SUM(CASE WHEN return_status = 'Rejected' THEN return_claim_amount ELSE 0 END), 2) AS rejected_amount_saved
FROM returnss;

-- 3). Monthly Return Trends Over Time:
SELECT
    DATE_FORMAT(r.return_date, '%Y-%m') AS return_month,
    COUNT(*) AS total_returns
FROM returnss r
GROUP BY return_month
ORDER BY return_month;

-- 4). Return Status Distribution (% Share & Total Refunded Amount):
SELECT
    return_status,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM returnss), 2) AS pct_share,
    ROUND(SUM(actual_refund), 2) AS total_actual_refund
FROM returnss
GROUP BY return_status
ORDER BY total DESC;

-- 5). Top Primary Reasons for Order Returns (% Distribution):
SELECT
    return_reason,
    COUNT(*) AS total_returns,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM returnss), 2) AS pct_share
FROM returnss
GROUP BY return_reason
ORDER BY total_returns DESC;

-- 6). Category Level Return Rate Percentage:
SELECT
    p.category,
    COUNT(DISTINCT oi.order_item_id) AS total_items_sold,
    COUNT(DISTINCT CASE WHEN r.return_id IS NOT NULL THEN oi.order_item_id END) AS returned_items,
    ROUND(COUNT(DISTINCT CASE WHEN r.return_id IS NOT NULL THEN oi.order_item_id END) * 100.0/ COUNT(DISTINCT oi.order_item_id), 2) AS return_rate_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN returnss r 
    ON r.order_id = oi.order_id 
   AND (r.order_item_id IS NULL OR r.order_item_id = oi.order_item_id)
WHERE o.order_status IN ('Delivered', 'Returned')
GROUP BY p.category
ORDER BY return_rate_pct DESC;

-- 7). Category-Wise Breakdown of Return Reasons:
SELECT
    p.category,
    r.return_reason,
    COUNT(DISTINCT r.return_id) AS total
FROM returnss r
JOIN orders o ON o.order_id = r.order_id
JOIN order_items oi 
    ON oi.order_id = o.order_id 
   AND (r.order_item_id IS NULL OR r.order_item_id = oi.order_item_id)
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category, r.return_reason
ORDER BY p.category, total DESC;

-- 8). Order Cancellation Reasons Analysis (% Share of Cancelled Orders):
SELECT
    cancellation_reason,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders WHERE order_status='Cancelled'), 2) AS pct_share
FROM orders
WHERE order_status = 'Cancelled'
GROUP BY cancellation_reason
ORDER BY total DESC;

-- 9). Category-Wise Return Scope: Whole Order vs Partial Item Returns:
SELECT
    p.category,
    COUNT(DISTINCT CASE WHEN r.order_item_id IS NULL THEN r.return_id END) AS whole_order_returns,
    COUNT(DISTINCT CASE WHEN r.order_item_id IS NOT NULL THEN r.return_id END) AS partial_item_returns,
    COUNT(DISTINCT r.return_id) AS total_category_returns
FROM returnss r
JOIN order_items oi 
    ON r.order_id = oi.order_id 
   AND (r.order_item_id IS NULL OR r.order_item_id = oi.order_item_id)
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_category_returns DESC;