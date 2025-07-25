# SQL-Retail-Sales-Analytics
Advanced SQL project analyzing sales data using complex business queries

A SQL-only portfolio project built to simulate a retail business and extract actionable business insights using advanced SQL.

## 📦 Database Schema

- `customers`: customer_id, name, email, join_date, region
- `orders`: order_id, customer_id, order_date, order_status
- `order_items`: item_id, order_id, product_id, quantity, unit_price
- `products`: product_id, name, category, price, stock_qty
- `payments`: payment_id, order_id, payment_method, payment_date, amount

Scripts:
- `schema.sql` – Creates all required tables
- `insert_data.sql` – Generates mock data using SQL

## 🧠 Key Business Insights (Queries)
1. Top 5 Customers by Total Spending
2. Monthly Revenue Trend
3. Repeat vs New Customers by Month
4. Average Order Value per Region
5. Rank Products by Sales (RANK function)
6. Churned Customers (no orders in last 90 days)
7. Running Total Revenue (Window function)
8. Most Common Payment Method per Month
9. % of Orders That Are Returned or Cancelled
10. Cancellation Rate by Region
11. Product Seasonality Trend

## 🧠 Skills Demonstrated

- Joins, CTEs, Window Functions, RANK(), Conditional Aggregation
- Date functions: `EXTRACT()`, `DATEDIFF()`
- Customer segmentation & time-series trend analysis
- Real-world business KPIs (churn, AOV, retention, return rates)

## 🚀 How to Run
1. Clone this repo
2. Open schema.sql and insert_data.sql in MySQL/PostgreSQL
3. Execute queries in /queries/ for insights 
