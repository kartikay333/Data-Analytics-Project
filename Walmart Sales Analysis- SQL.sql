#Task 1: Identifying the Top Branch by Sales Growth Rate
WITH MonthlySales AS (
    SELECT Branch, 
           MONTH(STR_TO_DATE(Transaction_date, '%d-%m-%Y')) AS Month_, 
           YEAR(STR_TO_DATE(Transaction_date, '%d-%m-%Y')) AS Year_, 
           SUM(Total_Sales) AS TotalSales_
    FROM c4.SalesData
    GROUP BY Branch, Year_, Month_
)
SELECT Branch, 
       Month_, 
       Year_, 
       TotalSales_,
       (TotalSales_ - LAG(TotalSales_) OVER (PARTITION BY Branch ORDER BY Year_, Month_)) / LAG(TotalSales_) OVER (PARTITION BY Branch ORDER BY Year_, Month_) AS GrowthRate
FROM MonthlySales
ORDER BY GrowthRate;

#Task 2: Finding the Most Profitable Product Line for Each Branch
SELECT branch, product_line, SUM(gross_income - cogs) AS total_profit
FROM c4.salesdata
GROUP BY branch, product_line
ORDER BY branch, total_profit DESC;

#Task 3: Analyzing Customer Segmentation Based on Spending
SELECT customer_id, SUM(total_sales) AS total_spent,
       CASE
           WHEN SUM(total_sales) > 21000 THEN 'High'
           WHEN SUM(total_sales) BETWEEN 15000 AND 20000 THEN 'Medium'
           ELSE 'Low'
       END AS spending_tier
FROM c4.salesdata
GROUP BY customer_id;

#Task 4: Detecting Anomalies in Sales Transactions
WITH product_avg_sales AS (
    SELECT product_line, AVG(total_sales) AS avg_sales
    FROM c4.salesdata
    GROUP BY product_line
)
SELECT sd.transaction_date, sd.product_line, sd.total_sales, pa.avg_sales
FROM c4.salesdata sd
JOIN product_avg_sales pa ON sd.product_line = pa.product_line
WHERE sd.total_sales > pa.avg_sales * 1.5 OR sd.total_sales < pa.avg_sales * 0.5;

#Task 5: Most Popular Payment Method by City
SELECT city, payment, COUNT(*) AS num_transactions
FROM c4.salesdata
GROUP BY city, payment
ORDER BY city, num_transactions DESC;

#Task 6: Monthly Sales Distribution by Gender
SELECT MONTH(STR_TO_DATE(Transaction_date, '%d-%m-%Y')) AS month_, gender, (total_sales) AS total_sales_
FROM c4.salesdata
GROUP BY month_, gender, total_sales_;

#Task 7: Best Product Line by Customer Type
SELECT customer_type, product_line, SUM(total_sales) AS total_sales_
FROM c4.salesdata
GROUP BY customer_type, product_line
ORDER BY customer_type, total_sales_ DESC;

#Task 8: Identifying Repeat Customers
SELECT customer_id, 
       COUNT(*) AS purchase_count,
       MIN(STR_TO_DATE(transaction_date, '%d-%m-%Y')) AS first_purchase,
       MAX(STR_TO_DATE(transaction_date, '%d-%m-%Y')) AS last_purchase,
       DATEDIFF(MAX(STR_TO_DATE(transaction_date, '%d-%m-%Y')), MIN(STR_TO_DATE(transaction_date, '%d-%m-%Y'))) AS days_between
FROM c4.salesdata
GROUP BY customer_id
HAVING purchase_count > 1
   AND DATEDIFF(MAX(STR_TO_DATE(transaction_date, '%d-%m-%Y')), MIN(STR_TO_DATE(transaction_date, '%d-%m-%Y'))) <= 90;

#Task 9: Finding Top 5 Customers by Sales Volume
SELECT customer_id, SUM(total_sales) AS total_sales_
FROM c4.salesdata
GROUP BY customer_id
ORDER BY total_sales_ DESC
LIMIT 5;

#Task 10: Analyzing Sales Trends by Day of the Week
SELECT DAYNAME(STR_TO_DATE(transaction_date, '%Y-%m-%d')) AS day_of_week, SUM(total_sales) AS total_sales_
FROM c4.salesdata
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');





