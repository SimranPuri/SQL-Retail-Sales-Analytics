#Top 5 customers by total spending
select c.name, sum(p.amount) as total_spent from customers c 
inner join orders o on c.customer_id= o.customer_id
inner join payments p on p.order_id= o.order_id
group by c.customer_id, c.name
order by total_spent desc limit 5; 


#Monthly Revenue Trend
select sum(amount) as monthly_revenue, DATE_FORMAT(payment_date, '%Y-%m') AS month
from payments
group by DATE_FORMAT(payment_date, '%Y-%m')
order by month;

#Repeat vs New Customers by Month
WITH first_order AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
),

monthly_orders AS (
    SELECT 
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        f.first_order_date
    FROM orders o
    JOIN first_order f ON o.customer_id = f.customer_id
)

SELECT 
    month,
    COUNT(DISTINCT CASE WHEN DATE_FORMAT(first_order_date, '%Y-%m') = month THEN customer_id END) AS new_customers,
    COUNT(DISTINCT CASE WHEN DATE_FORMAT(first_order_date, '%Y-%m') < month THEN customer_id END) AS repeat_customers
FROM monthly_orders
GROUP BY month
ORDER BY month;

#Average order value per region
select c.region, round(sum(p.amount) / count(distinct o.order_id),2) as avg_order_value
from customers c inner join orders o on c.customer_id = o.customer_id
inner join payments p on p.order_id = o.order_id 
group by c.region 
order by avg_order_value desc;

#Rank products by sales using RANK()
select p.product_id, p.name  as product_name, sum(oi.quantity) as quantity_sold,
rank() over(order by sum(oi.quantity)desc) rnk 
from products p 
inner join order_items oi 
on p.product_id = oi.product_id
group by p.product_id, p.name
order by rnk;

#Churned Customers (no order in last 90 days)
select c.customer_id, c.name, max(o.order_date) as last_order_date 
from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
having max(o.order_date) < Current_date -Interval 90 Day or max(o.order_date) is null
order by last_order_date;

#Running Total Revenue by month
select sum(amount) monthly_revenue, date_format(payment_date, '%Y-%m') as month,
sum(sum(amount)) over(order by date_format(payment_date, '%Y-%m')) as running_total
from payments 
group by date_format(payment_date, '%Y-%m')
order by month;	

#Most common payment method per month
with most_common_method as (
select payment_method, date_format(payment_date, '%Y-%m') as month, count(*)as method_count,
rank() over(partition by date_format(payment_date, '%Y-%m') order by count(*) desc) rnk
from payments 
group by date_format(payment_date, '%Y-%m'), payment_method)
select month, payment_method, method_count 
from most_common_method 
where rnk=1;

#% of Orders That Are Returned or Cancelled
select 
round(sum(case when order_status in('Returned', 'Cancelled') then 1 else 0 end)*100.0 / count(*),2) as percent_returned_cancelled
from orders;

#Cancellation Rate by Region
select c.region, count(*) as total_orders, 
sum(case when o.order_status in('Returned', 'Cancelled') then 1 else 0 end) AS cancelled_orders,
round(sum(case when o.order_status in('Returned', 'Cancelled') then 1 else 0 end)*100.0 / count(*),2) as percent_returned_cancelled
from orders o
inner join customers c 
on c.customer_id = o.customer_id
group by c.region
order by percent_returned_cancelled;

#Product Seasonality Trend
select p.name as product_name, date_format(o.order_date, '%Y-%m')as month, sum(oi.quantity) as total_qty_sold
from orders o
inner join order_items oi on o.order_id = oi.order_id
inner join products p on p.product_id = oi.product_id 
group by p.name, month
order by p.name,month;