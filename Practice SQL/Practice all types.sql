SELECT * FROM employee_salaries;
SELECT * from employees;
SELECT * from orders;
SELECT * FROM students;
SELECT * from products;
SELECT * FROM movies;
SELECT * FROM transactions;
SELECT * FROM monthly_revenue;
SELECT * FROM employee_salaries;
SELECT * FROM flights;
SELECT * FROM stocks;
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM sales;
SELECT *, dense_rank() OVER(ORDER by Salary desc) as ran FROM employees LIMIT 2;
SELECT * from (select *,dense_rank() OVER(ORDER by OrderDate desc) as order_time  from orders) as ranked_orders WHERE order_time=1;
with order_cte as(
select *,dense_rank() over(ORDER by OrderDate DESC) as order_time from orders
)
SELECT * from order_cte where order_time=1;
with score_cte as(
SELECT *,dense_rank() OVER(ORDER by ExamScore DESC) as 'Rank' FROM students
)
SELECT Rank,StudentID,StudentName,ExamScore from score_cte ORDER by 'Rank';
with sales_cte as (
SELECT * ,dense_rank() OVER(order by TotalSales desc) as sales_rank FROM products
)
SELECT sales_rank,ProductID,ProductName,Category,TotalSales FROM sales_cte ORDER by sales_rank;

WITH movie_cte as (
SELECT *,dense_rank() OVER(ORDER by rating DESC) as 'Rank' FROM movies 
)
 SELECT Rank,MovieID,MovieName,Rating FROM movie_cte;
 --avg revenue flactuate from previous month
 with revenue_cte as(
 SELECT * ,lag(Revenue) OVER (ORDER BY Month) as PreviousMonthRevenue FROM monthly_revenue
 )
 SELECT abs(avg(Revenue-PreviousMonthRevenue)) FROM revenue_cte;

 SELECT *,lag(Salary) OVER (PARTITION by EmployeeID ORDER BY EffectiveDate) as PreviousSalary FROM employee_salaries;
 with next_flight as(
 SELECT *,lead(DepartureTime) OVER(PARTITION BY Airline ORDER by Airline) as NextFlightDeparture FROM flights
 )
 SELECT * FROM next_flight WHERE DepartureTime<NextFlightDeparture;
 with next_cte as(
 SELECT *,lead(ClosingPrice) OVER(PARTITION BY StockID ORDER BY StockDate) as NextDayPrice  FROM stocks
 )
 SELECT * FROM next_cte WHERE ClosingPrice<NextDayPrice;
 --lag is for previous data and lead is for next data
 with dept_salary as(
 SELECT *,rank() OVER(PARTITION by DepartmentID ORDER by Salary DESC) as SalaryRankInDepartment FROM employees
 )
 SELECT * FROM dept_salary;
 WITH roll_cte as(
 SELECT *,avg(Amount) OVER(PARTITION by CustomerID ORDER by OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as AvgOrderAmountToDate from orders
 )
 SELECT * FROM roll_cte;
 -- UNBOUNDED PRECEDING: All rows before current row are considered.
--UNBOUNDED FOLLOWING: All rows after the current row are considered.
--CURRENT ROW: Range starts or ends at CURRENT ROW.
WITH previous_spending as(
SELECT *, lag(Amount) OVER(PARTITION by CustomerID ORDER by TransactionDate) as PreviousAmount FROM transactions
)
SELECT *, CASE 
WHEN PreviousAmount<Amount THEN 'Yes' 
ELSE 'No'
END as 'Increased (Yes/No)'
FROM previous_spending;

--ROW_NUMBER function is a SQL ranking function that assigns a sequential rank number to each new record in a partition.
with row_count as(
SELECT *, row_number() OVER(PARTITION by CustomerID ORDER by TransactionDate) as purchase FROM transactions
)
SELECT *,CASE
WHEN purchase=1 THEN 'Yes'
ELSE 'No'
END as 'IsFirstPurchase (Yes/No)'
FROM row_count;
--CTE 
WITH MonthlySpending AS (
  SELECT strftime('%Y-%m', OrderDate) AS Month, CustomerID, SUM(Amount) AS TotalSpend,
         ROW_NUMBER() OVER (PARTITION BY strftime('%Y-%m', OrderDate) ORDER BY SUM(Amount) DESC) AS Rank
  FROM orders
  GROUP BY Month, CustomerID
) --we can use Month function in mysql INSTEAD of strftime
SELECT * FROM MonthlySpending WHERE Rank <= 3;

WITH avg_revenue as (
SELECT avg(Revenue) as avgrev from monthly_revenue
)
SELECT Month,Revenue,
CASE when Revenue>1.5*(SELECT avgrev FROM avg_revenue) THEN 'Yes'
ELSE 'No'
END as Above150Percent
FROM monthly_revenue;

with second_avg as (
SELECT *, dense_rank() OVER(PARTITION by CustomerID ORDER by Amount) as 'Rank' FROM transactions 
)
SELECT CustomerID,Amount,Rank,
CASE WHEN Rank=2 THEN 'Yes'
ELSE 'No'
END as 'OnlyIfRank=2' FROM second_avg;



WITH DeptAvg AS (
  SELECT DepartmentID, AVG(Salary) AS AvgSalary
  FROM employees
  GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.DepartmentID, e.Salary,
       CASE WHEN e.Salary > 2 * d.AvgSalary THEN 'Yes' ELSE 'No' END AS TwiceAboveAvg
FROM employees e
JOIN DeptAvg d ON e.DepartmentID = d.DepartmentID;

SELECT c.CustomerID,c.Name FROM customers c LEFT JOIN orders o on c.CustomerID=o.CustomerID WHERE o.OrderID is NULL; 

SELECT p.ProductID,p.ProductName FROM products p RIGHT join order_items o on p.ProductID=o.ProductID where o.OrderID is NULL;

SELECT p.Category,sum(p.TotalSales) as TotalRevenue,s.Region FROM products p LEFT JOIN sales s on p.ProductID=s.SaleID GROUP by p.Category;

with avg_spend as(
SELECT *,round(avg(Amount),2) as avg_spending FROM orders GROUP by CustomerID
)
SELECT CustomerID,Amount as TotaSpend FROM avg_spend where Amount>avg_spending;

with Nth_highest_salary as (
SELECT *,dense_rank() over(PARTITION by DepartmentID ORDER by Salary desc) as 'rank' FROM employees
)
SELECT DepartmentID,EmployeeName,EmployeeID,Salary FROM Nth_highest_salary WHERE rank=1;
SELECT DepartmentID,EmployeeName,EmployeeID,Salary FROM Nth_highest_salary WHERE rank=2;
SELECT DepartmentID,EmployeeName,EmployeeID,Salary FROM Nth_highest_salary WHERE rank=3;

SELECT c.CustomerID
FROM orders o
JOIN products p
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID
HAVING COUNT(DISTINCT o.OrderID) = (SELECT COUNT(*) FROM products);

SELECT ProductID,(Quantity*Price) as TotalRevenue FROM order_items GROUP by ProductID;

SELECT CustomerID,round(avg(Amount),2) as AverageOrderValue FROM orders GROUP by CustomerID;

SELECT strftime('%m',OrderDate) as Month , count(*) as OrderCount FROM orders GROUP by Month;

SELECT CustomerID, COUNT(*) AS OrderCount
FROM orders
GROUP BY CustomerID
ORDER BY OrderCount DESC
LIMIT 1;

SELECT CustomerID,strftime('%Y',OrderDate) as year, count(*) as OrderCount FROM orders GROUP by CustomerID,Year;




