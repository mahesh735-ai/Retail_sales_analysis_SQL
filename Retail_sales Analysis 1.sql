--0.1 SQL Retail Sales Analysis

CREATE DATABASE SQL_Projects;

-- Now Create TABLE
DROP TABLE IF EXISTS retail_sales

CREATE TABLE Retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35), 
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales

--IMPORT the csv ( Header option should be on while importing data) 

SELECT * FROM retail_sales
LIMIT 10; -- to understand the data

--to check record

SELECT Count(*) 
FROM retail_sales --correctly import


--"Data Cleaning"

--Find the null values 
SELECT * FROM Retail_sales
WHERE 
	transactions_id is null
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	gender IS NULL
	OR 
	customer_id IS NULL
	OR 
	quantity IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

--Delete Data Where Null Present
DELETE FROM retail_sales
WHERE 
	transactions_id is null
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	gender IS NULL
	OR 
	customer_id IS NULL
	OR 
	quantity IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

--"DATA Exploration"

--How many sales we have?
SELECT COUNT (*) AS total_sales
From retail_sales

--how many unique customers we have?
SELECT COUNT(DISTINCT customer_id ) as total_customers
From retail_sales

--Categories ?
SELECT DISTINCT category as categories
From retail_sales

--"Data Analysis & Business Key Problems with Answers"

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
 
 SELECT * FROM retail_sales
 where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--we need 3 condition to find result

SELECT * FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND
	TO_CHAR(sale_Date,'YYYY-MM')= '2022-11' --in november
	AND
	quantity >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
	category , 
	SUM(total_sale) as net_sales,
	COUNT(*) AS total_orders
from retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	Round(AVG(age),2) as avg_age_Cust
FROM retail_sales
WHERE Category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	gender,
	category,
	COUNT(transactions_id) AS total_transactions
From retail_sales
group by 1,2
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as ranks
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE ranks = 1

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	customer_id,
	sum(total_sale) as total_sales
FROM Retail_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT * FROM retail_sales

SELECT category, COUNT(DISTINCT Customer_id) AS Unique_Customers
FROM retail_sales
GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders 
--(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH Hourly_sale
as
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shifts
FROM retail_sales
)
SELECT shifts,COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shifts


SELECT EXTRACT(HOUR FROM CURRENT_TIME )

         --*END OF PROJECT*--