create database if not exists salesDataWalmart;

create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(10) not null,
    gender varchar(10) not null ,
    product_line varchar(100) not null ,
    unit_price decimal(10,2) not null,
    quantity int not null,
    tax float(6,4) not null,
    total decimal(12,4)not null,
    date datetime not null,
    time time not null,
    payment varchar(15)not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9),
    gross_income decimal(12,4) not null,
    rating float(2,1)not null
);


-- feature engineering

select time from sales;

select time,
(case
	when 'time' between '00:00:00' and "12:00:00" then "Morning" 
	when 'time' between '12:00:00' and "16:00:00" then "Evening" 
    else "night" 
end) as time_of_day
from sales;

alter table sales add column time_of_day varchar(20);

SET SQL_SAFE_UPDATES = 0 ; 

update sales set time_of_day = (case
	when 'time' between '00:00:00' and "12:00:00" then "Morning" 
	when 'time' between '12:00:00' and "16:00:00" then "Evening" 
    else "night" 
end);

-- DAY_NAME
select date,dayname(date) as day_name
from sales;

alter table sales add day_name varchar(12) not null ;
update sales set day_name = dayname(date);

-- month name
select date,monthname(date) as month_name
from sales; 

alter table sales add month_name varchar(12) not null ;
update sales set month_name = monthname(date);


-- exploratory data analysis

--  Generic Question
-- ------------------------------------------------------------------------------

-- How many unique cities does the data have?
select distinct city from sales;

-- In which city is each branch?
select distinct city ,branch 
from sales;


-- Product
-- ------------------------------------------------------------------------------
-- How many unique product lines does the data have?
select count( distinct product_line) from sales;

-- What is the most common payment method?
select payment,count(payment) as count
from sales
group by payment 
order by count desc;

-- What is the most selling product line?
select distinct product_line ,sum(quantity) as max_quan
from sales
group by product_line
order by max_quan desc;

-- What is the total revenue by month?
select month_name,sum(total) as max_tot
from sales
group by month_name
order by max_tot desc ;

-- What month had the largest COGS?
select month_name ,max(cogs) as cogs
from sales
group by month_name
order by cogs;

-- What product line had the largest revenue?
select product_line, sum(total) as revenue
from sales
group by product_line
order by revenue desc
limit 5;

-- What is the city with the largest revenue?
select city, sum(total) as revenue
from sales
group by city
order by revenue desc
limit 2;

-- What product line had the largest VAT or tax?
select product_line ,max(tax) as max_tax
from sales
group by product_line
order by max_tax desc
limit 3 ;

-- Which branch sold more products than average product sold?
select branch,sum(quantity) as qty 
from sales
group by branch
having sum(quantity)> (select avg(quantity) from sales);

-- What is the most common product line by gender?
select gender,product_line,count(gender) as tot_count
from sales
group by gender,product_line
order by tot_count desc ;

-- What is the average rating of each product line?
select product_line,avg(rating) as avg_rating
from sales
group by product_line
order by avg_rating desc ;

-- Sales
-- ------------------------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sales
from sales
group by  time_of_day
order by total_sales desc; 

-- Which of the customer types brings the most revenue?
select customer_type,max(total) as revenue
from sales
group by customer_type
order by revenue desc limit 5;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,max(tax) as max_tax
from sales
group by city
order by max_tax desc limit 3;

-- Which customer type pays the most in VAT?
select customer_type,max(tax) as max_tax
from sales
group by customer_type
order by max_tax desc limit 3;

-- Customer
-- -------------------------------------------------------------------------------
-- How many unique customer types does the data have?
select distinct customer_type from sales;

-- How many unique payment methods does the data have?
select distinct payment from sales;

-- What is the most common customer type?
select customer_type, count(*) as cnt_cust
from sales
group by customer_type;

-- Which customer type buys the most?
select customer_type, sum(total) as max_revenue
from sales
group by customer_type
order by max_revenue desc;

-- What is the gender of most of the customers?
select gender,count(*) as cnt_cust
from sales
group by gender
order by cnt_cust;

-- What is the gender distribution per branch?
select branch,gender,count(*) as cnt_cust
from sales
group by gender,branch
order by cnt_cust  desc;

-- Which time of the day do customers give most ratings?
select time_of_day,max(rating) as max_rat
from sales
group by time_of_day
order by  max_rat desc limit 5;

-- Which day of the week has the best avg ratings?
select day_name,avg(rating) as best_rat
from sales
group by day_name
order by  best_rat desc limit 5;

-- Which day of the week has the best average ratings per branch?
select branch , day_name,avg(rating) as best_rat
from sales
group by branch,day_name
order by  best_rat desc limit 5;