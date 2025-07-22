drop table if exists zepto;

create table zepto(
sku_id SERIAL primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuanitity INTEGER,
discountedSellingPrice numeric(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
); 

--data exploration
select count(*) from zepto;

--sample data
select * from zepto limit 10;

--null values
select * from zepto where 
name is null or
category is null or
mrp is null or
discountPercent is null or
availableQuanitity is null or
discountedSellingPrice is null or
weightInGms is null or
outOfStock is null or
quantity is null;

--different product categories
select distinct category from zepto order by category;

--products in stock vs out of stock
select outOfStock,count(sku_id)
from zepto group by outOfStock;

--product names present multiple times
select name,count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

-- data cleaning
--products with price=0
select * from zepto
where mrp=0 or discountedSellingPrice=0;

delete from zepto where mrp=0;

--convert paise to rupees
update zepto
set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto;

-- Q1. Find the top 10 best-value products based on the discount percentage.
select sku_id,category,name,discountpercent,discountedsellingprice from zepto group by sku_id order by discountpercent desc limit 10;

--Q2.What are the Products with High MRP but Out of Stock
select * from zepto group by sku_id having outofstock= true order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category,sum(discountedsellingprice*availablequanitity) as Revenue from zepto group by category order by Revenue desc;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select * from zepto group by sku_id having mrp>500 and discountpercent<10.0 order by discountedsellingprice desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,avg(discountpercent) as averagepercent from zepto group by category order by averagepercent desc limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,weightInGms, discountedSellingPrice,round(discountedsellingprice/weightingms,2) as price_per_gram from zepto where weightingms>=100 order by price_per_gram desc;
--Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name,weightInGms,
case when weightInGms<1000 then 'Low'
when weightInGms<5000 then 'Medium'
else 'Bulk' end as weight_category from zepto order by weightInGms desc;

--Q8.What is the Total Inventory Weight Per Category 
select category,sum(weightInGms*discountedSellingPrice) as total_weight from zepto group by category order by total_weight desc;

