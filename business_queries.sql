USE olist_db;

-- ================================================================================
--  SALES ANALYSIS
-- ================================================================================

-- What is the total revenue generated?
SELECT
	ROUND(SUM(payment_value), 2) AS 'Total Revenue Generated'
FROM order_payments;

--  What is the total revenue generated per month?
SELECT
	YEAR(o.order_purchase_timestamp) AS 'Year',
    MONTH(o.order_purchase_timestamp) AS 'Month',
    ROUND(SUM(op.payment_value), 2) AS 'Total Revenue Generated'
FROM orders o
JOIN order_payments op
	USING (order_id)
GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
ORDER BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp);

-- What are the top 10 product categories by revenue?
SELECT 
	ct.product_category_name_english AS 'Product',
    ROUND(SUM(op.payment_value), 2) AS 'Revenue'
FROM order_payments op
JOIN order_items ot
	USING(order_id)
JOIN products p
	USING (product_id)
JOIN category_translate ct
	ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY Revenue DESC
LIMIT 10;

-- What is the average order value?
WITH orders_total AS (
	SELECT
		order_id,
        SUM(payment_value) AS order_total
	FROM order_payments
    GROUP BY order_id
)
SELECT
	ROUND(AVG(order_total), 2) AS 'Average Order Value'
    FROM orders_total;
    
-- How many orders were placed each year?
SELECT
	YEAR(order_purchase_timestamp) AS 'Year',
    COUNT(order_id) AS 'Number of Orders'
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp);

-- ================================================================================
-- CUSTOMER ANALYSIS 
-- ================================================================================

-- How many unique customers placed orders?
SELECT
	COUNT(DISTINCT customer_unique_id) AS 'Unique Customers'
FROM customers;

-- Which states have the highest number of customers?
SELECT 
	customer_state AS 'State',
    COUNT(DISTINCT customer_unique_id) AS 'No. of Customers'
FROM customers 
GROUP BY customer_state
ORDER BY COUNT(DISTINCT customer_unique_id) DESC;

-- How many customers made more than one purchase?
WITH repeat_customers AS (
SELECT 
	c.customer_unique_id,
    COUNT(o.customer_id) AS no_of_orders
FROM customers c
JOIN orders o
	USING(customer_id)
GROUP BY c.customer_unique_id
	HAVING COUNT(o.customer_id) >= 2
)
 
 SELECT
	COUNT(customer_unique_id) AS 'Repeat Customers'
FROM repeat_customers;

-- ================================================================================
--  ORDER & DELIVERY ANALYSIS
-- ================================================================================

-- How many orders are in each status?
SELECT
	order_status,
    COUNT(order_status) AS 'Order Count'
FROM orders
GROUP BY order_status;

-- What is the average delivery time in days?
SELECT
	ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS 'Average Delivery Time (Days)'
FROM orders;

-- How many orders were delivered late?
SELECT
    COUNT(order_id) AS 'Late Orders'
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date
AND order_status = 'delivered';

-- ================================================================================
-- PRODUCT & SELLER ANALYSIS 
-- ================================================================================

-- Who are the top 10 sellers by revenue?
SELECT
	oi.seller_id AS 'Seller',
    ROUND(SUM(op.payment_value), 2) AS 'Revenue'
FROM order_items oi
JOIN order_payments op
	USING(order_id)
GROUP BY oi.seller_id
ORDER BY Revenue DESC
LIMIT 10;

-- What is the average review score per product category?
SELECT 
	ct.product_category_name_english AS 'Product',
    ROUND(AVG(r.review_score), 1) AS 'Average Score'
FROM order_reviews r
JOIN order_items oi
	USING(order_id)
JOIN products p
	USING(product_id)
JOIN category_translate ct
	ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY AVG(r.review_score) DESC;

-- ================================================================================
-- ADVANCED ANALYSIS
-- ================================================================================

-- How much did revenue grow or drop compared to last month?
WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS yr,
        MONTH(o.order_purchase_timestamp) AS mn,
        ROUND(SUM(op.payment_value), 2) AS revenue
    FROM orders o
    JOIN order_payments op
        USING (order_id)
    GROUP BY yr, mn
)
SELECT
    yr AS 'Year',
    mn AS 'Month',
    revenue AS 'Revenue',
    LAG(revenue) OVER (ORDER BY yr, mn) AS 'Last Month Revenue',
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY yr, mn)) / LAG(revenue) OVER (ORDER BY yr, mn)) * 100, 2) AS 'MoM Growth %'
FROM monthly_revenue;