drop table if exists retail;
--databse setup
create table retail(
transaction_id INT PRIMARY KEY,	
sale_date DATE,	 
sale_time TIME,	
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),	
quantity	INT,
price_per_unit FLOAT,	
cogs	FLOAT,
total_sale FLOAT
);

--EXPLORING & CLEANING
select * from retail limit 10;

select * from retail 
where transaction_id is null or
sale_date is null or
sale_time is null or
customer_id is null or
gender is null or
age	 is null or
category is null or
quantity is null or
price_per_unit is null or
cogs is null or
total_sale is null;

delete from retail where 
transaction_id is null or
sale_date is null or
sale_time is null or
customer_id is null or
gender is null or
age	 is null or
category is null or
quantity is null or
price_per_unit is null or
cogs is null or
total_sale is null;

--DATA ANALYSIS & FINDINGS
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail where sale_date='2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail where category = 'Clothing' and quantity>=4 and to_char(sale_date,'yyyy-mm')='2022-11';

--3.Write a SQL query to calculate the total sales (total_sale) for each category.:
select category,sum(total_sale) as sales from retail group by category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age),2) as average_age from retail where category = 'Beauty';

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select transaction_id,total_sale from retail where total_sale>1000 order by total_sale desc;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category,gender,count(transaction_id) as transactions from retail group by category,gender order by transactions desc;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
with best_selling as(
select to_char(sale_date,'yyyy') as year,to_char(sale_date,'yyyy-mm') as month,avg(total_sale) as avg_sale from retail group by month,year
),rank_month as(
select *,dense_rank() over(partition by year order by avg_sale desc) as rnk from best_selling
)
select year,month,avg_sale from rank_month where rnk=1 order by year;

--8.Write a SQL query to find the top 5 customers based on the highest total sales.:
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail
GROUP BY category

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift