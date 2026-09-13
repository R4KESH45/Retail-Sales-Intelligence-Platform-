-- =============================================================
-- SmartMart Retail Sales & Customer Intelligence Analytics
-- MySQL Workbench Data Generation Script
-- Author: Training Project Kit
-- Purpose: Create 5-table beginner-friendly SQL resume project dataset
-- Approx Records: Customers 20K, Products 5K, Employees 2K,
--                 Orders 20K, Order_Items 40K
-- =============================================================
DROP DATABASE IF EXISTS smartmart_retail_sql_project;
CREATE DATABASE smartmart_retail_sql_project;
USE smartmart_retail_sql_project;
SET SESSION cte_max_recursion_depth = 50000;

-- ===============================================================
-- 1. CUSTOMERS TABLE
-- ===============================================================
CREATE TABLE customers(
customer_id int primary key,
customer_name varchar(100) not null,
gender varchar(20) not null,
city varchar(50) not null,
state varchar(50) not null,
registration_date date not null,
customer_segment varchar(30) default 'Regular',
email varchar(120) unique,
phone_number varchar(15) unique,
check (gender in ('Male','Female','Other')),
check (customer_segment in ('Regular','Silver','Gold','Platinum'))
);
-- ==================================================================
-- 2. EMPLOYEES TABLE
-- ==================================================================
create table employees (
employee_id int primary key,
employee_name varchar(100) not null,
gender varchar(20) not null,
city varchar(50) not null,
department varchar(50) not null default 'Sales',
joining_date date not null,
salary decimal(10,2) not null,
check (gender in ('Male','Female','Other')),
check (salary >= 10000)
);
-- ====================================================================
-- 3. PRODUCTS TABLE
-- ====================================================================
create table products (
product_id int primary key,
product_name varchar(150) not null,
category varchar(60) not null,
brand varchar(80) not null,
unit_price decimal(10,2) not null,
cost_price decimal(10,2) not null,
launch_date date not null,
product_status varchar(20) default 'Active',
check (unit_price > 0),
check (cost_price > 0),
check (product_status in ('Active','Inactive'))
);
-- =====================================================================
-- 4. ORDERS TABLE
-- =====================================================================
create table orders (
order_id int primary key,
customer_id int not null,
employee_id int not null,
order_date date not null,
order_status varchar(30) not null default 'Completed',
payment_mode varchar(30) not null,
foreign key (customer_id) references customers(customer_id),
foreign key (employee_id) references employees(employee_id),
check (order_status in ('Completed','Cancelled','Returned')),
check (payment_mode in ('Cash','UPI','Credit Card','Debit Card','Net Banking'))
);
-- =============================================================================
-- 5. ORDER_ITEMS TABLE
-- =============================================================================
create table order_items(
order_item_id int primary key,
order_id int not null,
product_id int not null,
quantity int not null,
unit_price decimal(10,2) not null,
discount_percent decimal(5,2) default 0,
line_total decimal(12,2) not null,
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products(product_id),
check (quantity > 0),
check (unit_price > 0),
check (discount_percent between 0 and 50)
);

-- ===================================================================================
-- INSERT 20000 CUSTOMERS
-- ===================================================================================
insert into customers 
(customer_id, customer_name, gender, city, state, registration_date, customer_segment, email, phone_number)
with recursive numbers as (
select 1 as n
union all 
select n+1 from numbers where n < 20000
)
select 
	100000 + n as customer__id,
    concat('Customer_', n) as customer_name,
    case mod(n,3)
    when 0 then 'Male'
    when 1 then 'Female'
    else 'Other'
    end as gender,
    case mod(n,8)
    when 0 then 'Hyderabad'
    when 1 then 'Bengaluru'
    when 2 then 'Chennai'
    when 3 then 'Mumbai'
    when 4 then 'Pune'
    when 5 then 'Delhi'
    when 6 then 'Kolkata'
    else 'Ahmedabad'
    end as city,
	case mod(n,8)
    when 0 then 'Telengana'
    when 1 then 'Karnataka'
    when 2 then 'Tamilnadu'
    when 3 then 'Maharashtra'
    when 4 then 'Maharashtra'
    when 5 then 'Delhi'
    when 6 then 'West Bangal'
    else 'Gujurat'
    end as state,
    date_add('2021-01-01',interval mod(n, 1460) day) as registration_date,
    case 
    when mod(n,20) = 0 then 'Platinum'
    when mod(n,10) = 0 then 'Gold'
    when mod(n,5) = 0 then 'Silver'
    else 'Regular'
    end as customer_segment,
    concat('customer',n,'@smartmartmail.com') as email,
    concat('9',lpad(n,9,'0')) as phone_number
    from numbers;
-- =============================================================
-- INSERT 2,000 EMPLOYEES
-- =============================================================
INSERT INTO employees
(employee_id, employee_name, gender, city, department, joining_date, salary)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 2000
)
SELECT
    50000 + n AS employee_id,
    CONCAT('Employee_', n) AS employee_name,
    CASE MOD(n,3)
        WHEN 0 THEN 'Male'
        WHEN 1 THEN 'Female'
        ELSE 'Other'
    END AS gender,
    CASE MOD(n,6)
        WHEN 0 THEN 'Hyderabad'
        WHEN 1 THEN 'Bengaluru'
        WHEN 2 THEN 'Chennai'
        WHEN 3 THEN 'Mumbai'
        WHEN 4 THEN 'Pune'
        ELSE 'Delhi'
    END AS city,
    CASE MOD(n,4)
        WHEN 0 THEN 'Sales'
        WHEN 1 THEN 'Customer Support'
        WHEN 2 THEN 'Store Operations'
        ELSE 'Billing'
    END AS department,
    DATE_ADD('2020-01-01', INTERVAL MOD(n, 1800) DAY) AS joining_date,
    18000 + (MOD(n, 60) * 1000) AS salary
FROM numbers;

-- =============================================================
-- INSERT 5,000 PRODUCTS
-- =============================================================
INSERT INTO products
(product_id, product_name, category, brand, unit_price, cost_price, launch_date, product_status)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 5000
)
SELECT
    200000 + n AS product_id,
    CONCAT('Product_', n) AS product_name,
    CASE MOD(n,8)
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Fashion'
        WHEN 2 THEN 'Grocery'
        WHEN 3 THEN 'Home Appliances'
        WHEN 4 THEN 'Beauty'
        WHEN 5 THEN 'Sports'
        WHEN 6 THEN 'Furniture'
        ELSE 'Stationery'
    END AS category,
    CASE MOD(n,10)
        WHEN 0 THEN 'Samsung'
        WHEN 1 THEN 'Apple'
        WHEN 2 THEN 'Nike'
        WHEN 3 THEN 'Puma'
        WHEN 4 THEN 'LG'
        WHEN 5 THEN 'Sony'
        WHEN 6 THEN 'Boat'
        WHEN 7 THEN 'Prestige'
        WHEN 8 THEN 'Himalaya'
        ELSE 'SmartMart'
    END AS brand,
    CASE MOD(n,8)
        WHEN 0 THEN 15000 + MOD(n, 40000)
        WHEN 1 THEN 500 + MOD(n, 5000)
        WHEN 2 THEN 50 + MOD(n, 2000)
        WHEN 3 THEN 3000 + MOD(n, 25000)
        WHEN 4 THEN 100 + MOD(n, 3000)
        WHEN 5 THEN 300 + MOD(n, 7000)
        WHEN 6 THEN 5000 + MOD(n, 50000)
        ELSE 20 + MOD(n, 1000)
    END AS unit_price,
    ROUND((
        CASE MOD(n,8)
            WHEN 0 THEN 15000 + MOD(n, 40000)
            WHEN 1 THEN 500 + MOD(n, 5000)
            WHEN 2 THEN 50 + MOD(n, 2000)
            WHEN 3 THEN 3000 + MOD(n, 25000)
            WHEN 4 THEN 100 + MOD(n, 3000)
            WHEN 5 THEN 300 + MOD(n, 7000)
            WHEN 6 THEN 5000 + MOD(n, 50000)
            ELSE 20 + MOD(n, 1000)
        END
    ) * 0.70, 2) AS cost_price,
    DATE_ADD('2021-01-01', INTERVAL MOD(n, 1600) DAY) AS launch_date,
    CASE WHEN MOD(n,25) = 0 THEN 'Inactive' ELSE 'Active' END AS product_status
FROM numbers;

-- =============================================================
-- INSERT 20,000 ORDERS
-- =============================================================
INSERT INTO orders
(order_id, customer_id, employee_id, order_date, order_status, payment_mode)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 20000
)
SELECT
    300000 + n AS order_id,
    100000 + MOD(n, 20000) + 1 AS customer_id,
    50000 + MOD(n, 2000) + 1 AS employee_id,
    DATE_ADD('2023-01-01', INTERVAL MOD(n, 900) DAY) AS order_date,
    CASE
        WHEN MOD(n,20) = 0 THEN 'Returned'
        WHEN MOD(n,15) = 0 THEN 'Cancelled'
        ELSE 'Completed'
    END AS order_status,
    CASE MOD(n,5)
        WHEN 0 THEN 'Cash'
        WHEN 1 THEN 'UPI'
        WHEN 2 THEN 'Credit Card'
        WHEN 3 THEN 'Debit Card'
        ELSE 'Net Banking'
    END AS payment_mode
FROM numbers;

-- =============================================================
-- INSERT 40,000 ORDER ITEMS
-- =============================================================
INSERT INTO order_items
(order_item_id, order_id, product_id, quantity, unit_price, discount_percent, line_total)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 40000
)
SELECT
    400000 + n AS order_item_id,
    300000 + MOD(n, 20000) + 1 AS order_id,
    p.product_id,
    1 + MOD(n, 5) AS quantity,
    p.unit_price AS unit_price,
    CASE
        WHEN MOD(n,10) = 0 THEN 20
        WHEN MOD(n,5) = 0 THEN 10
        ELSE 0
    END AS discount_percent,
    ROUND((1 + MOD(n, 5)) * p.unit_price *
        (1 - (
            CASE
                WHEN MOD(n,10) = 0 THEN 20
                WHEN MOD(n,5) = 0 THEN 10
                ELSE 0
            END / 100)), 2) AS line_total
FROM numbers
JOIN products p
    ON p.product_id = 200000 + MOD(n, 5000) + 1;
-- ==========================================================================
-- 1. Customer Analysis
-- ===========================================================================
-- 1. Management wants to know the total number of customers available for sales and marketing campaigns.
select count(*) as total_customer from customers;
-- 2. Management wants to understand which cities have the strongest customer presence.
select city, count(customer_id) as total_customers
from customers group by city order by total_customers desc;
-- 3. The company wants to identify customers who contribute the highest revenue.
select c.customer_id, 
c.customer_name,
c.city, 
round(sum(oi.quantity * oi.unit_price),2) as total_revenue
from customers c join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id, c.customer_name, c.city
order by total_revenue desc
limit 10;
-- 4. Management wants to know how many customers are purchasing more than once.
select c.customer_id , c.customer_name ,
count(o.order_id) as total_orders
from customers c join orders o 
on c.customer_id = o.customer_id
group by c.customer_id , c.customer_name
having count(o.order_id) > 1
order by total_orders desc;
-- 5. The company wants to identify registered customers who have not placed any orders
select c.customer_id , c.customer_name, c.city
from customers c 
left join orders o
on c.customer_id = o.customer_id
where o.order_id is null;
-- 6. Management wants to segment customers based on total spending.
with customer_revenue as (
select c.customer_id, c.customer_name, sum(oi.quantity * oi.unit_price) as total_spent
from customers c join orders o 
on c.customer_id = o.customer_id 
join order_items oi on o.order_id = oi.order_id
group by c.customer_id , c.customer_name
)
select customer_id,
customer_name, round(total_spent,2) as total_spent,
case 
when total_spent >= 100000 then 'VIP Customer'
when total_spent >= 50000 then 'High Value Customer'
when total_spent >= 20000 then 'Regular Customer'
else 'Low Value Customer'
end as customer_segment
from customer_revenue
order by total_spent desc;
-- ==========================================================================
-- 2. Product Analysis
-- ==========================================================================
-- 1. Management wants to identify products that generate the highest revenue.
select p.product_id, 
       p.product_name,
       p.category,
       round(sum(oi.quantity*oi.unit_price),2) as total_revenue
from products p 
join order_items oi
on p.product_id = oi.product_id
group by p.product_id, p.product_name,p.category
order by total_revenue desc
limit 10;
-- 2. The company wants to know which products are most frequently purchased.
select p.product_id,
	   p.product_name,
       p.category,
       sum(oi.quantity) as total_quantity_sold
	from products p 
    join order_items oi
    on p.product_id = oi.product_id
    group by p.product_id, p.product_name, p.category
    order by total_quantity_sold desc
    limit 10;
-- 3. Management wants to identify products that are listed but never sold.
select p.product_id,
       p.product_name,
       p.category
from products p 
left join order_items oi
on p.product_id = oi.product_id
where oi.product_id is null;
-- 4. Management wants to know which product categories perform best.
select p.category,
       round(sum(oi.quantity * oi.unit_price),2) as category_revenue
from products p 
join order_items oi
on p.product_id = oi.product_id 
group by p.category
order by category_revenue desc;
-- 5. Management wants to identify products generating very low revenue
select p.product_id,
       p.product_name,
       p.category,
       round(sum(oi.quantity * oi.unit_price),2) as revenue 
from products p 
join order_items oi
on p.product_id = oi.product_id
group by p.product_id , p.product_name , p.category
having revenue < 5000
order by revenue asc;
-- 6. Management wants to rank products within each category.
select product_id, product_name, category, total_revenue, 
       dense_rank() over(partition by category 
						 order by total_revenue desc
                         ) as product_rank
		from (
        select p.product_id,
                p.product_name,
                p.category,
                round(sum(oi.quantity * oi.unit_price),2) as total_revenue
			from products p 
            join order_items oi
            on p.product_id = oi.product_id
            group by p.product_id , p.product_name, p.category
            ) as product_sales;
-- =========================================================================================
-- 3. Sales Analysis
-- =========================================================================================
-- 1. Management wants to know total business revenue
select round(sum(quantity * unit_price),2) as total_revenue
from order_items;
-- 2. Management wants to understand monthly revenue movement
select 
      year(o.order_date) as sales_year,
      month(o.order_date) as sales_month,
      round(sum(oi.quantity * oi.unit_price),2) as monthly_revenue
	from orders o 
    join order_items oi
    on o.order_id = oi.order_id 
    group by year(o.order_date) , month(o.order_date)
    order by sales_year, sales_month;
-- 3. Management wants to compare revenue across quarters.
SELECT
    YEAR(o.order_date) AS sales_year,
    QUARTER(o.order_date) AS sales_quarter,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS quarterly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
ORDER BY sales_year, sales_quarter;
-- 4. Management wants to know the average revenue generated per order
with order_revenue as (
      select order_id,
              sum(quantity * unit_price) as order_value
		from order_items group by order_id
        )
select round(avg(order_value),2) as average_order_value
from order_revenue;
-- 5. Management wants to identify premium transactions
with order_revenue as (
       select order_id,
               sum(quantity * unit_price) as order_value
	     from order_items group by order_id
         )
select order_id ,
      round(order_value,2) as order_value
      from order_revenue
      where order_value > (
            select avg(order_value)
            from order_revenue
            )
	order by order_value desc;
-- ========================================================================================
-- 4. Employees Analysis
-- ========================================================================================
-- 1. Management wants to evaluate sales employee contribution.
select e.employee_id,
       e.employee_name,
       round(sum(oi.quantity * oi.unit_price),2) as revenue_generated
	from employees e 
    join orders o 
    on e.employee_id = o.employee_id
    join order_items oi
    on o.order_id = oi.order_id
    group by e.employee_id , e.employee_name 
    order by revenue_generated desc;
-- 2.Management wants to identify best performers
select 
      employee_id ,
      employee_name ,
      revenue_generated,
      dense_rank() over(order by revenue_generated desc) as employee_rank
      from(
          select e.employee_id,
				 e.employee_name,
                 sum(oi.quantity * oi.unit_price) as revenue_generated
			from employees e 
            join orders o 
            on e.employee_id = o.employee_id 
            join order_items oi
            on o.order_id = oi.order_id
            group by e.employee_id, e.employee_name
            ) as emp_sales
            limit 10;
-- 3. Management wants to identify employees not linked to any orders
select e.employee_id,
	   e.employee_name
	from employees e 
    left join orders o 
    on e.employee_id = o.employee_id
    where o.order_id is null;
-- ==============================================================================
-- Some Advance Buisness Analysis
-- ==============================================================================
-- Management wants to identify products performing better than average.
with product_revenue as (
select 
	  p.product_id,
      p.product_name,
      sum(oi.quantity * oi.unit_price) as revenue
      from products p 
      join order_items oi
      on p.product_id = oi.product_id
      group by p.product_id, p.product_name
      )
      select product_id , product_name,
             round(revenue,2) as revenue
             from product_revenue
             where revenue > 
             (select avg(revenue) from product_revenue)
             order by revenue desc;
-- Management wants to understand cumulative revenue growth.
with monthly_sales as (
		select 
              year(o.order_date) as sales_year,
              month(o.order_date) as sales_month,
              sum(oi.quantity * oi.unit_price) as monthly_revenue
              from orders o 
              join order_items oi 
              on o.order_id = oi.order_id 
              group by year(o.order_date), month(o.order_date)
              )
			select 
                sales_year, sales_month, 
                round(monthly_revenue,2) as monthly_revenue,
                round(sum(monthly_revenue) over(order by sales_year,sales_month),2
                ) as running_revenue 
                from monthly_sales;
-- Management wants to identify customers spending more than average.
with customer_spending as (
       select 
            c.customer_id ,
            c.customer_name ,
            sum(oi.quantity * oi.unit_price) as total_spent
            from customers c 
            join orders o 
            on c.customer_id = o.customer_id
            join order_items oi 
            on o.order_id = oi.order_id 
            group by c.customer_id , c.customer_name
            )
		 select 
              customer_id ,
              customer_name,
              round(total_spent,2) as total_spent
              from customer_spending
              where total_spent > (
                   select avg(total_spent)
                   from customer_spending
                   ) order by total_spent desc;
-- ============================================================================
-- Set Operation Analysis
-- ============================================================================
-- Management wants to combine customers from two key cities
select customer_id, customer_name, city
from customers 
where city = 'Hyderabad'
union 
select customer_id, customer_name, city
from customers 
where city = 'Bangalore';
-- Management wants to compare registered customers and purchasing customers.
SELECT customer_id, 'Registered Customer' AS customer_type
FROM customers
UNION ALL
SELECT customer_id, 'Purchased Customer' AS customer_type
FROM orders;









