CREATE DATABASE ecommerce_project;
USE ecommerce_project;
SELECT COUNT(*) FROM customers_clean;
SELECT COUNT(*) FROM orders_clean;
SELECT COUNT(*) FROM order_items_clean;
SELECT COUNT(*) FROM products_clean;
SELECT COUNT(*) FROM payments_clean;
SELECT COUNT(*) FROM reviews_clean;
SELECT COUNT(*) FROM sellers_clean;

# SQL ANALYSIS 
# 1 — Monthly Revenue Trend
SELECT
    o.purchase_year,
    o.purchase_month,
    ROUND(SUM(oi.item_total),2) AS monthly_revenue
FROM orders_clean o
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
GROUP BY o.purchase_year, o.purchase_month
ORDER BY o.purchase_year, o.purchase_month;

# 2. Top Selling Products
SELECT
    product_id,
    COUNT(*) AS quantity_sold
FROM order_items_clean
GROUP BY product_id
ORDER BY quantity_sold DESC
LIMIT 10;

# 3. Highest Revenue Products
SELECT
    product_id,
    ROUND(SUM(item_total),2) AS revenue
FROM order_items_clean
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;

# 4. Top Revenue Categories
SELECT
    p.product_category_name,
    ROUND(SUM(oi.item_total),2) AS revenue
FROM order_items_clean oi
JOIN products_clean p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

# 5. Top Cities by Revenue
SELECT
    c.customer_city,
    ROUND(SUM(oi.item_total),2) AS revenue
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 10;

# 6. Top States by Revenue
SELECT
    c.customer_state,
    ROUND(SUM(oi.item_total),2) AS revenue
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

# 7. Repeat Customers
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders_clean
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;

# 8. New vs Returning Customers
SELECT
    CASE
        WHEN total_orders = 1 THEN 'New Customer'
        ELSE 'Returning Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM
(
    SELECT
        customer_id,
        COUNT(*) AS total_orders
    FROM orders_clean
    GROUP BY customer_id
) t
GROUP BY customer_type;

# 9. Average Order Value (AOV)
SELECT
    ROUND(
        SUM(item_total) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items_clean;

# 10. Delivery Delay Analysis 
SELECT
    CASE
        WHEN delivery_delay_days > 0 THEN 'Late'
        WHEN delivery_delay_days = 0 THEN 'On Time'
        ELSE 'Early'
    END AS delivery_status,
    COUNT(*) AS total_orders
FROM orders_clean
GROUP BY delivery_status;

# 11. Payment Method Analysis
SELECT
    payment_type,
    COUNT(*) AS transactions,
    ROUND(SUM(payment_value),2) AS total_payment
FROM payments_clean
GROUP BY payment_type
ORDER BY total_payment DESC;

# 12. Seller Performance
SELECT
    seller_id,
    ROUND(SUM(item_total),2) AS revenue
FROM order_items_clean
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;

# 13. Customer Purchase Frequency
SELECT
    customer_id,
    COUNT(order_id) AS purchase_frequency
FROM orders_clean
GROUP BY customer_id
ORDER BY purchase_frequency DESC;

# 14. Highest Rated Products
SELECT
    oi.product_id,
    ROUND(AVG(r.review_score),2) AS avg_rating
FROM reviews_clean r
JOIN order_items_clean oi
    ON r.order_id = oi.order_id
GROUP BY oi.product_id
ORDER BY avg_rating DESC
LIMIT 10;

# 15. Lowest Rated Products
SELECT
    oi.product_id,
    ROUND(AVG(r.review_score),2) AS avg_rating
FROM reviews_clean r
JOIN order_items_clean oi
    ON r.order_id = oi.order_id
GROUP BY oi.product_id
ORDER BY avg_rating ASC
LIMIT 10;

# 16. Seasonal Sales Trends (Quarter-wise)
SELECT
    o.purchase_quarter,
    ROUND(SUM(oi.item_total),2) AS revenue
FROM orders_clean o
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
GROUP BY o.purchase_quarter
ORDER BY o.purchase_quarter;

# 17. Region-wise Customer Distribution
SELECT
    customer_state,
    COUNT(*) AS customers
FROM customers_clean
GROUP BY customer_state
ORDER BY customers DESC;

# 18. Order Status / Cancellation Analysis
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders_clean
GROUP BY order_status
ORDER BY total_orders DESC;

# Only cancellations:
SELECT
    COUNT(*) AS cancelled_orders
FROM orders_clean
WHERE order_status = 'cancelled';

# 19. Review Sentiment Analysis
SELECT
    CASE
        WHEN review_score >= 4 THEN 'Positive'
        WHEN review_score = 3 THEN 'Neutral'
        ELSE 'Negative'
    END AS sentiment,
    COUNT(*) AS total_reviews
FROM reviews_clean
GROUP BY sentiment;

# 20. Peak Purchase Month Analysis
SELECT
    purchase_month,
    COUNT(*) AS total_orders
FROM orders_clean
GROUP BY purchase_month
ORDER BY total_orders DESC;

-- Bonus Analysis (Good for Final Year Project)
-- Top 10 Customers by Spending
SELECT
    c.customer_id,
    ROUND(SUM(oi.item_total),2) AS total_spent
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Revenue by Gender
SELECT
    c.gender,
    ROUND(SUM(oi.item_total),2) AS revenue
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
GROUP BY c.gender;

-- Revenue by Age Group
SELECT
    age_group,
    COUNT(*) AS customers
FROM customers_clean
GROUP BY age_group;
