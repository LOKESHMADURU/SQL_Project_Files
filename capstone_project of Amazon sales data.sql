create database sql_capstone_project;

use sql_capstone_project;

create table project
like amazon;

select * from project;

insert project
	select * from amazon;
    
ALTER TABLE project CHANGE COLUMN `Invoice ID` Invoice_ID text;

ALTER TABLE project CHANGE COLUMN `Customer type` Customer_type text;

ALTER TABLE project CHANGE COLUMN `Product line` Product_line text;

ALTER TABLE project CHANGE COLUMN `Unit price` Unit_price double;

ALTER TABLE project CHANGE COLUMN `Tax 5%` Tax_five_percentage double;

ALTER TABLE project CHANGE COLUMN `gross margin percentage` gross_margin_percentage double;

ALTER TABLE project CHANGE COLUMN `gross income` gross_income double;

delete from project
where Invoice_ID is null or 
Branch is null or 
Customer_type is null or 
Gender is null or 
Product_line is null or 
Unit_price is null or 
Quantity is null or 
Tax_five_percentage is null or 
Total is null or 
Date is null or 
Time is null or 
Payment is null or 
cogs is null or 
gross_margin_percentage is null or
 gross_income is null or
 Rating is null; 

alter table project add column timeofday varchar(10);

set sql_safe_updates = 0;

update project 
	set timeofday= 
		case
		when time(Time)>='00:00:00' and time(Time)<'12:00:00' then 'morning'
        when time(Time)>='12:00:00' and time(Time)<'17:00:00' then 'afternoon'
        else 'evening'
	end;

alter table project add column dayname varchar(10);

update project
set dayname=dayname(Date);

alter table project add column monthname varchar(10);

update project 
set monthname=monthname(Date);

-- 1) What is the count of distinct cities in the dataset?
select 
	count(distinct city) as 'count of distinct city' 
from 
	project;

-- 2) For each branch, what is the corresponding city?
select 
	branch, city 
from 
	project 
group by 
	Branch, city;

-- 3) What is the count of distinct product lines in the dataset?
select 
	count(distinct Product_line) as 'count of product line' 
from 
	project;
 
-- 4) Which payment method occurs most frequently?
select 
	Payment, count(Payment) as 'most frequently payment' 
from 
	project 
group by 
	Payment 
order by 
	count(Payment) desc;

-- 5) Which product line has the highest sales?
select 
	Product_line, count(Quantity) as 'highest sales' 	
from 
	project 
group by 
	Product_line 
order by 
	count(Quantity) desc;

-- 6) How much revenue is generated each month?
select 
	monthname, sum(Unit_price*Quantity) as 'revenue' 
from 
	project 
group by 
	monthname;

-- 7) In which month did the cost of goods sold reach its peak?
select 
	monthname, sum(Unit_price*Quantity) as 'revenue' 
from 
	project 
group by 
	monthname 
order by 
	revenue desc;

-- 8) Which product line generated the highest revenue?
select 
	Product_line, sum(Unit_price*Quantity) as 'revenue' 
from 
	project 
group by
	Product_line 
order by 
	revenue desc;

-- 9) In which city was the highest revenue recorded?
select
	city, sum(Unit_price*Quantity) as 'revenue' 
from 
	project 
group by 
	city 
order by 
	revenue desc;

-- 10) Which product line incurred the highest Value Added Tax?
select 
	Product_line, sum(Tax_five_percentage) as 'highest tax' 
from 
	project 
group by 
	Product_line 
order by 
	`highest tax`;

-- 11) For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
with avg_productline as(
	select avg(Quantity) as avg_quantity from project
),
cte as(
select product_line, case
	when Quantity > (select avg_quantity from avg_productline) then 'Good'
	else 'Bad'
    end as 'Review' from project 
    )
  select * from cte;  
    
-- 12) Identify the branch that exceeded the average number of products sold.
select 
	Branch 
from 
	project 
where 
	Quantity >(select avg(Quantity) from project) 
group by 
	Branch;

-- 13) Which product line is most frequently associated with each gender?
select 
	Product_line, gender, count(Product_line) as 'most frequently productline' 
from 
	project
group by 
	gender, Product_line 
order by 
	`most frequently productline` desc;

-- 14) Calculate the average rating for each product line ?
select
	Product_line, avg(rating) as 'avg rating' 
from 
	project 
group by 
	Product_line;

-- 15) Count the sales occurrences for each time of day on every weekday?
select 
	dayname, count(Quantity) as sales_occurrences 
from 
	project 
group by 
	dayname;

-- 16) Identify the customer type contributing the highest revenue?
select 
	customer_type, sum(unit_price*quantity) 
from 
	project 
group by 
	customer_type;

-- 17) Determine the city with the highest VAT percentage?
select 
	city, round(sum(Tax_five_percentage),2) as 'VAT percentage' 
from 
	project 
group by 
	city 
order by 
	sum(Tax_five_percentage) desc;

-- 18) Identify the customer type with the highest VAT payments?
select 
	Customer_type, round(sum(Tax_five_percentage),2) as 'VAT percentage' 
from 
	project 
group by 
	Customer_type 
order by 
	sum(Tax_five_percentage) desc;

-- 19) What is the count of distinct customer types in the dataset?
select 
	count(distinct customer_type) 
from 
	project;

-- 20) What is the count of distinct payment methods in the dataset?
select 
	count(distinct payment) 
from 
	project;

-- 21) Which customer type occurs most frequently?
select 
	Customer_type, count(*) 
from 
	project 
group by
	customer_type;

-- 22) Identify the customer type with the highest purchase frequency?
select 
	Customer_type, count(unit_price) 
from 
	project 
group by 
	customer_type;

-- 23) Determine the predominant gender among customers?
select 
	Gender, count(*) 
from 
	project 
group by 
	Gender;

-- 24) Examine the distribution of genders within each branch?
select 
	Branch, 
		(select count(Gender) from project where Gender='Female' ) as count_of_Females, 
			count(Gender) as count_of_Males from project 
where 
	Gender='Male' 
group by 
	Branch 
order by 
	Branch;

-- 25) Identify the time of day when customers provide the most ratings?
select 
	timeofday, count(Rating) as count_of_Rating 
from 
	project 
group by 
	timeofday;

-- 26) Determine the time of day with the highest customer ratings for each branch?
select 
	Branch, timeofday, count(Rating) as count_of_Rating 
from 
	project 
group by 
	timeofday, Branch;

-- 27) Identify the day of the week with the highest average ratings?
select
	dayname, round(avg(Rating), 2) as count_of_Rating
from 
	project 
group by 
	dayname;

-- 28) Determine the day of the week with the highest average ratings for each branch?
select 
	Branch, dayname, round(avg(Rating), 2) as count_of_Rating 
from
	project
group by 
	dayname, Branch 
order by 
	Branch;






