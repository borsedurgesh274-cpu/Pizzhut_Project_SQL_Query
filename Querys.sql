-- Basic:
-- Retrieve the total number of orders placed.

select * from orders;

select count(order_id) as total_orders
 from orders;
 
-- Calculate the total revenue generated from pizza sales.

select * from pizzas;
select* from order_details;

select round(sum(p.price * o.quantity),2) as total_revenu from pizzas p
join order_details o
on p.pizza_id = o.pizza_id;


-- Identify the highest-priced pizza.

select * from pizzas;
select * from pizza_types;

select  ps.name,p.price as High_price_pizza
 from pizzas p
 join pizza_types ps
 on ps.pizza_type_id = p.pizza_type_id
 group by name, price
 order by p.price desc
 limit 1;
 
 
-- Identify the most common pizza size ordered.

select * from order_details;
select * from pizzas;
select p.size,count(o.order_details_id) as order_count
from pizzas p
join order_details o
on p.pizza_id = o.pizza_id
group by size 
order by order_count desc;

-- List the top 5 most ordered pizza types along with their quantities.

select * from order_details ;
select * from pizza_types ;
select * from pizzas;

select ps.name ,sum(o.quantity) as total_Quantity
from pizza_types ps
join pizzas p
on p.pizza_type_id = ps.pizza_type_id
join order_details o
on o.pizza_id =p.pizza_id
group by ps.name
order by total_quantity desc
limit 5;

 -- intermediate
 
-- Join the necessary tables to find the total quantity of each pizza category orderd.

select pt.category,sum(o.quantity) as Quantity
from pizza_types pt 
join pizzas p
on  pt.pizza_type_id =p.pizza_type_id
join order_details o
on o.pizza_id= p.pizza_id
group by pt.category
order by quantity desc;

-- Determine the distribution of orders by hour of the day.

SELECT HOUR(order_time) AS hour, COUNT(order_id) AS Order_count
FROM orders
GROUP BY HOUR(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.

select category ,count(name) as pizza_count
from pizza_types
group by category ;


-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT ROUND(AVG(total_order), 0) as AVG_pizza_order_perday
FROM
    (SELECT o.order_date, SUM(od.quantity) AS total_order
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY order_date) AS Order_Quantity;


-- Determine the top 3 most ordered pizza types based on revenue.

select * from pizzas;
select * from order_details;  
select * from pizza_types;
select pt.name ,sum(p.price * od.quantity) as total_revenu
from pizza_types pt
join pizzas p
on p.pizza_type_id= pt.pizza_type_id
join order_details  od
on p.pizza_id = od.pizza_id
group by name
order by total_revenu desc
limit 3;

-- Advanced:

-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT pt.category,ROUND(SUM(od.quantity * p.price) * 100 /
        (
            SELECT SUM(od.quantity * p.price)
            FROM order_details od
            JOIN pizzas p
			ON od.pizza_id = p.pizza_id
        ),
        2
) AS revenue_percentage
FROM pizza_types pt
JOIN pizzas p
    ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od
    ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue_percentage DESC;

-- Analyze the cumulative revenue generated over time.

select order_date,sum(revenue) over (order by  order_date) as cum_revenue from
(select o.order_date,sum(od.quantity * p.price) as revenue
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id
join orders o
on o.order_id = od.order_id
group by order_date)as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name,revenu from (select category, name ,revenu ,
rank() over (partition by category order by revenu desc) as total_revenu from
(select pt.category,pt.name,
sum(od.quantity * p.price) as revenu
from pizza_types pt
join pizzas p
on p.pizza_type_id= pt.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by category,name)as total) as b
where total_revenu<=3;

