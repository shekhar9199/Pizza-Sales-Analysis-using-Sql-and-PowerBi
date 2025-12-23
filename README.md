# 🍕 Pizza Sales Analysis (SQL + Power BI)
<h1>🖼️ Dashboard Preview</h1>
<br>
⭐ 1. Executive Overview 
<p align="center"><img width="1216" height="741" alt="Image" src="https://github.com/user-attachments/assets/b01bbb16-f07c-4996-bb67-3aed8dac738d" /></p> <br>
⭐ 2. Product & Pricing Strategy
<p align="center"><img width="1222" height="682" alt="Image" src="https://github.com/user-attachments/assets/a30f0694-3938-4168-8abe-7915ca476de0" /></p> <br>
⭐ 3. Customer Ordering Patterns
<p align="center"><img width="1218" height="678" alt="Image" src="https://github.com/user-attachments/assets/0c1170c4-b8ee-4a58-bfcc-694494e1850c" /></p> <br>


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

