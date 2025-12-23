# 🍕 Pizza Sales Analysis (SQL + Power BI)

## 📌 Project Overview
This project analyzes pizza sales data to uncover revenue trends, product performance, and customer ordering behavior.

The solution includes:
- A normalized MySQL database schema
- Fast CSV ingestion using staging tables
- Business-focused Power BI dashboards

---

## 🛠 Tech Stack
- MySQL 8.0
- SQL (DDL, DML, Joins, Constraints)
- Power BI
- CSV Data

---

## 🗄️ Database Design
- Normalized schema with foreign keys
- Parent-to-child table insertion
- Staging tables for fast data loading

Tables:
- `orders`
- `order_details`
- `pizzas`
- `pizza_types`

---

## 🚀 Data Loading Strategy
- Used `LOAD DATA LOCAL INFILE` for fast ingestion
- Loaded data into staging tables first
- Inserted validated records into main tables using joins
- Maintained referential integrity

---

## 📊 Power BI Dashboard
### Page 1 – Executive Overview
- Revenue, Orders, AOV
- Monthly trends
- Top pizzas and categories

### Page 2 – Product & Sales Deep Dive
- Size-wise sales
- Top pizzas by revenue
- Quantity vs revenue analysis

### Page 3 – Customer Ordering Patterns
- Peak order hours
- Day-wise demand
- Seasonal trends
- Average pizzas per order

---

## 💡 Key Business Insights
- Classic pizzas generate the highest revenue
- Peak demand occurs during evening hours
- Customers order ~2.3 pizzas per order on average
- Weekends drive higher order volumes

