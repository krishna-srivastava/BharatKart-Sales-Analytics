USE bharatkart;

SELECT * FROM customers LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM returnss LIMIT 5;

-- F). Payment Level Analysis:
-- 1). Payment Method Market Share (% Distribution across all transactions):
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payment), 2) AS pct_share
FROM payment
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- 2). Payment Gateway Reliability: Success vs Failed Count & Success Rate %:
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN payment_status = 'Success' THEN 1 ELSE 0 END) AS success_count,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_count,
    ROUND(SUM(CASE WHEN payment_status = 'Success' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate_pct
FROM payment
GROUP BY payment_method
ORDER BY success_rate_pct DESC;

-- 3). Overall Payment Status Breakdown (Count, Share %, Total Amount):
SELECT
    payment_status,
    COUNT(*) AS total_transactions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payment), 2) AS pct_share,
    ROUND(SUM(payment_amount), 2) AS total_amount
FROM payment
GROUP BY payment_status
ORDER BY total_transactions DESC;

-- 4). Prepaid vs Cash on Delivery (COD) Comparison (Successful Transactions):
SELECT
    CASE WHEN payment_method = 'COD' THEN 'COD' ELSE 'Prepaid' END AS payment_type,
    COUNT(*) AS total_transactions,
    ROUND(AVG(payment_amount), 2) AS avg_amount,
    ROUND(SUM(payment_amount), 2) AS total_amount
FROM payment
WHERE payment_status = 'Success'
GROUP BY payment_type;

-- 5). Revenue & Order Volume Contribution by Payment Method (Delivered Orders):
SELECT
    p.payment_method,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS total_revenue,
    ROUND(AVG(oi.item_total), 2) AS avg_item_value
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN payment p ON p.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.payment_method
ORDER BY total_revenue DESC;

-- 6). Return Rate Percentage by Payment Method:
SELECT
    p.payment_method,
    COUNT(DISTINCT o.order_id) AS total_delivered_orders,
    COUNT(DISTINCT r.order_id) AS returned_orders,
    ROUND(COUNT(DISTINCT r.order_id) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS return_rate_pct
FROM orders o
JOIN payment p ON p.order_id = o.order_id
LEFT JOIN returnss r ON r.order_id = o.order_id
WHERE o.order_status IN ('Delivered','Returned')
GROUP BY p.payment_method
ORDER BY return_rate_pct DESC;

-- 7). Cancelled Orders Analysis: Breakdown by Payment Method & Status:
SELECT
    p.payment_method,
    p.payment_status,
    COUNT(*) AS total
FROM payment p
JOIN orders o ON o.order_id = p.order_id
WHERE o.order_status = 'Cancelled'
GROUP BY p.payment_method, p.payment_status
ORDER BY p.payment_method DESC;