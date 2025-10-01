--Most Common 15 SQL Questions for Interview

--1. Finding total sales for each month of the year 2023
select * from orders;

select extract(month from order_date) as month,TO_CHAR(order_date,'Month')as month_name,sum(order_amount) as total_sales from orders
where extract(year from order_date)=2023
group by extract(month from order_date),TO_CHAR(order_date,'Month')
order by month;

--2. Finding customers who placed orders after 1st January 2023

select * from orders;
select * from customers;

select c.customer_id,c.customer_name,c.email 
from customers c 
join orders o on c.customer_id=o.customer_id 
where order_date>'2023-01-01'
group by c.customer_id
order by c.customer_id;

--3.Second Highest Salary for Department 101
select * from employees;
with ss as(
select salary,dense_rank() over(partition by department_id order by salary) as rnk from employees where department_id=101
)
select salary from ss where rnk=2;

--4. Finding products that have never been sold
select * from products;
select * from order_items;
select p.product_id,p.product_name,p.category
from products p left join order_items oi 
on p.product_id=oi.product_id
where oi.product_id is NULL;

--5. Finding customers whose order amount exceeds 1000
select * from customers;
select * from orders;
select distinct c.customer_id,c.customer_name,c.email
from customers c inner join orders o on c.customer_id=o.customer_id 
where o.order_amount>1000
order by customer_id;

--6. Finding the total quantity for each product from stores in LA during 2023
select * from products;
select * from order_items;
select * from orders;
select * from stores;


select p.product_name,sum(oi.quantity) as total_quantity
from products p join order_items oi on p.product_id=oi.product_id
join orders o on oi.order_id=o.order_id join stores s on
o.store_id=s.store_id  where s.city='Los Angeles' and 
extract(year from o.order_date)=2023 group by p.product_name,p.product_id
order by total_quantity desc;

--7. Finding names of employees along with their direct managers
select * from employees;

select e.employee_name,m.employee_name as manager_name from employees e
left join employees m on e.manager_id=m.employee_id 
where e.manager_id is not null order by e.employee_name;

--8. Find customer name, total order amount, total payment amount for orders placed in 2023
select * from customers;
select * from orders;
select * from payments;

select c.customer_name,sum(o.order_amount) as total_order_amount,
sum(p.payment_amount) as total_payment_amount from customers c join orders o 
on c.customer_id=o.customer_id join payments p on o.order_id=p.order_id
where extract(year from o.order_date)=2023
group by c.customer_name
order by total_order_amount desc;

--9. Finding books that were not borrowed in the last 6 months
select * from books;
select * from book_borrowings;

select b.book_id,b.title,b.author 
from books b
where b.book_id not in(
select distinct bb.book_id from 
book_borrowings bb where
borrow_date>=CURRENT_DATE-INTERVAL '6 months'
);


--10.  Finding total salary expense for each department for the latest salary record only
select * from departments;
select * from employees;
select * from salary_history;

SELECT 
    d.department_name,
    SUM(latest_salaries.salary) as total_salary_expense
FROM departments d
INNER JOIN (
    SELECT 
        e.department_id,
        e.employee_id,
        sh.salary,
        ROW_NUMBER() OVER (PARTITION BY e.employee_id ORDER BY sh.effective_date DESC) as rn
    FROM employees e
    INNER JOIN salary_history sh ON e.employee_id = sh.employee_id
) latest_salaries ON d.department_id = latest_salaries.department_id AND latest_salaries.rn = 1
GROUP BY d.department_id, d.department_name
ORDER BY total_salary_expense DESC;


--11.  Finding products that have been ordered more than 5 times across all orders
select * from products;
select * from order_items;

select p.product_name,
count(*) as order_count
from products p join 
order_items oi on p.product_id=oi.product_id
group by p.product_name
having count(*)>5
order by order_count desc;

--12. Finding employees who earn more than the average salary of their respective departments
select * from employees;
select * from departments;

WITH avg_sal AS (
    SELECT d.department_id,
           d.department_name,
           round(AVG(e.salary),2) AS avg_salary
    FROM employees e
    JOIN departments d 
      ON e.department_id = d.department_id
    GROUP BY d.department_id, d.department_name
)
SELECT e.employee_name,
       e.salary,
       d.department_name,
       a.avg_salary
FROM employees e
JOIN departments d 
  ON e.department_id = d.department_id
JOIN avg_sal a 
  ON d.department_id = a.department_id
WHERE e.salary > a.avg_salary
order by e.salary desc;

--13. Rank each salesperson's sales for each product based on the amount
select * from sales;
select * from employees;
select * from products;

select e.employee_id,e.employee_name,p.product_name,
sum(s.sale_amount) as total_sales,
dense_rank() over(partition by e.employee_id order by sum(s.sale_amount) desc)as sales_rank
from employees e join sales s on e.employee_id=s.employee_id
join products p on s.product_id=p.product_id
group by e.employee_id,e.employee_name,s.product_id,p.product_name;

--14. Finding 7-day moving average of daily sales amount
select * from daily_sales;

select sale_date,total_amount,
round(avg(total_amount) over(order by sale_date rows between 6 preceding and current row),2) as moving_avg_7_days
from daily_sales
order by sale_date;

--15. Classifying students based on their scores using Case statements
select * from students;

select student_name,score,
case 
when score>=90 then 'A (Excellent)'
when score>=80 then 'B (Good)'
when score>=70 then 'C (Average)'
when score>=60 then 'D (Below Average)'
else 'F (Fail)'
end as grade,
case 
when score>=80 then 'Pass with Distinction'
when score>=60 then 'Pass'
else 'Fail'
end as result_status
from students
order by score desc;

--End
