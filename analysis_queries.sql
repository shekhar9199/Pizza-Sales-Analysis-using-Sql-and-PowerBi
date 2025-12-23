-- Loading process 
/* 
STEP 0: Open MySQL CMD correctly (IMPORTANT)
STEP 1: Always start like this 👇
		"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --local-infile=1 -u root -p
STEP 2: USE pizza_analysis; //SELECT DATABASE 

STEP 3: REMEMBER TO LOAD DATA IN STAGING TABLE FOR DATA QUALITY AND SAFETY

		TO LOAD PIZZA_TYPES TABLE 
		LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_dataset/pizza_types.csv'
		INTO TABLE pizza_types_raw
		CHARACTER SET latin1
		FIELDS TERMINATED BY ',' ENCLOSED BY '"'
		LINES TERMINATED BY '\r\n'
		IGNORE 1 ROWS;
		
        TO LOAD PIZZAS TABLE
        LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_dataset/pizzas.csv'
		INTO TABLE pizzas_raw
		FIELDS TERMINATED BY ',' ENCLOSED BY '"'
		LINES TERMINATED BY '\r\n'
		IGNORE 1 ROWS;
		
        TO LOAD ORDER TABLE 
        LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_dataset/orders.csv'
		INTO TABLE orders_raw
		FIELDS TERMINATED BY ',' ENCLOSED BY '"'
		LINES TERMINATED BY '\r\n'
		IGNORE 1 ROWS;

		TO LOAD ORDER_DETAILS TABLE
        LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_dataset/order_details.csv'
		INTO TABLE order_details_raw
		FIELDS TERMINATED BY ',' ENCLOSED BY '"'
		LINES TERMINATED BY '\r\n'
		IGNORE 1 ROWS;

*/
-- MAIN TABLE
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ingredients TEXT NOT NULL,
    PRIMARY KEY (pizza_type_id)
);

-- STAGING AREA 
CREATE TABLE pizza_types_raw (
    pizza_type_id VARCHAR(50),
    name VARCHAR(100),
    category VARCHAR(50),
    ingredients TEXT
);

-- INSERTING INTO MAIN TABLE
INSERT INTO pizza_types (pizza_type_id, name, category, ingredients)
SELECT
    pizza_type_id,
    name,
    category,
    ingredients
FROM pizza_types_raw;


-- pizza child of pizza_types
CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size CHAR(10),
    price DECIMAL(5,2),
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);
-- staging area 
CREATE TABLE pizzas_raw (
    pizza_id VARCHAR(50),
    pizza_type_id VARCHAR(50),
    size CHAR(10),
    price DECIMAL(5,2)
);
-- Insert into main table
INSERT INTO pizzas
SELECT pr.*
FROM pizzas_raw pr
JOIN pizza_types pt
  ON pr.pizza_type_id = pt.pizza_type_id;



-- MAIN TABLE
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    date DATE,
    time TIME
);
-- staging area 
CREATE TABLE orders_raw (
    order_id INT,
    order_date VARCHAR(20),
    order_time TIME
);
-- Insert (IMPORTANT date conversion)
INSERT INTO orders
SELECT
    order_id,
    STR_TO_DATE(order_date, '%d-%m-%Y'),
    order_time
FROM orders_raw;

select * from orders


-- final table order details 
CREATE TABLE order_details (
    order_details_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);
-- stagging area 
CREATE TABLE order_details_raw (
    order_details_id INT,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT
);
-- Insert with FK-safe joins
INSERT INTO order_details (order_id, pizza_id, quantity)
SELECT
    od.order_id,
    od.pizza_id,
    od.quantity
FROM order_details_raw od
JOIN orders o
  ON od.order_id = o.order_id
JOIN pizzas p
  ON od.pizza_id = p.pizza_id;


-- Final validation
SELECT COUNT(*) FROM pizza_types;
SELECT COUNT(*) FROM pizzas;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_details;


-- Deleting staging storage
DROP TABLE IF EXISTS
    order_details_raw,
    orders_raw,
    pizzas_raw,
    pizza_types_raw;



-- SOLVING BUSINESS PROBLEMS 

-- Q1 what is the total revenue?
-- This helps measure total sales generated from all orders.
SELECT ROUND(SUM(od.quantity * p.price),2) as Total_Revenue
FROM pizzas p
JOIN order_details od
ON p.pizza_id = od.pizza_id

-- Q2 What are the top 5 best-selling pizzas?
-- Business use
    -- Menu optimization & promotions.
SELECT pt.name AS Pizza_Name, SUM(od.quantity) as Total_Sold
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY Pizza_Name
ORDER BY Total_Sold DESC
LIMIT 5

-- Q3 Which pizza category generates the most revenue?
--    Business use
--    Focus marketing budget.
SELECT pt.category AS Pizza_Category, 
		ROUND(SUM(p.price * od.quantity),2) AS Total_Revenue
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY Pizza_Category
ORDER BY Total_Revenue DESC

-- Q4 What is the average order value (AOV)?
-- Business use
-- Pricing & upsell strategy.
SELECT ROUND(SUM(p.price * od.quantity) / COUNT(DISTINCT od.order_id),2) AS Avg_Order_Value
FROM pizzas p
JOIN order_details od 
	ON p.pizza_id = od.pizza_id

-- Q5 Which pizza size sells the most?
--    Business use
--    Inventory planning.
SELECT p.size, SUM(od.quantity) AS Total_Sold
FROM pizzas p
JOIN order_details od 
	ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY Total_Sold DESC

-- Q6 Peak ordering time (hour-wise)
-- Business use
-- Staffing & operations.
SELECT HOUR(time) AS Hour, 
	   COUNT(*) AS Total_Orders
FROM orders
GROUP BY Hour
ORDER BY Total_Orders DESC

-- Q7 Daily revenue trend
--    Business use
--    Identify growth or decline.
SELECT o.date, ROUND(SUM(p.price * od.quantity),2) AS Daily_Revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date

-- Q8 Find least selling Pizza.
--    Helps to Remove From Menu
SELECT pt.name AS Pizza_Name, SUM(od.quantity) as Total_Sold
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY Pizza_Name
ORDER BY Total_Sold ASC
LIMIT 5


