-- -------------------------------------------------------
-- -------------------------------------------------------
-- CUSTOMER CHURN PREDICTION SYSTEM DATABASE
-- -------------------------------------------------------
-- -------------------------------------------------------


-- --------------------------------
-- Creating and Using Database
-- --------------------------------
CREATE DATABASE IF NOT EXISTS Customer_Churn_System ;
USE Customer_Churn_System;

-- ---------------------------------
-- Creating tables inside Database
-- ---------------------------------
CREATE TABLE locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(50) UNIQUE
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    age INT,
    gender VARCHAR(10),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE usage_data (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    tenure INT,
    monthly_usage FLOAT,
    last_login_days INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    plan_type VARCHAR(20),
    monthly_charges FLOAT,
    contract_type VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE support_interactions (
    interaction_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    complaints INT,
    support_calls INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- --------------------------------
-- ML Prediction Target Table
-- --------------------------------
CREATE TABLE predictions (
    prediction_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    churn_probability FLOAT,
    predicted_label INT,
    prediction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ----------------------------------------
-- AUTOMATED RETENTION ACTION TABLE (Using TRIGGER)
-- ----------------------------------------
CREATE TABLE retention_actions (
    action_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    action_message VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ------------------------------
-- Inserting Values Into Tables
-- ------------------------------
INSERT INTO locations (city_name)
VALUES
('Jalandhar'),
('Delhi'),
('Mumbai'),
('Pune'),
('Bangalore'),
('Chandigarh'),
('Kolkata'),
('Chennai'),
('Hyderabad'),
('Jaipur'),
('Lucknow'),
('Ahmedabad'),
('Bhopal'),
('Indore'),
('Ranchi'),
('Bhubaneswar'),
('Nagpur'),
('Surat'),
('Noida'),
('Gurgaon'),
('Amritsar'),
('Ludhiana'),
('Kanpur'),
('Varanasi'),
('Kochi');

INSERT INTO customers(age, gender, location_id)
VALUES
(22,'Male',2),
(25,'Female',3),
(30,'Male',4),
(35,'Female',2),
(40,'Male',5),
(28,'Female',6),
(50,'Male',2),
(45,'Female',3),
(32,'Male',4),
(27,'Female',2),
(38,'Male',5),
(29,'Female',6),
(41,'Male',2),
(36,'Female',3),
(33,'Male',4),
(26,'Female',2),
(48,'Male',5),
(44,'Female',6),
(31,'Male',2),
(39,'Female',3),
(42,'Male',4),
(34,'Female',2),
(37,'Male',5),
(23,'Female',6),
(46,'Male',2);

INSERT INTO usage_data (customer_id, tenure, monthly_usage, last_login_days) 
VALUES
(1,12,20,15),
(2,2,85,2),
(3,8,40,10),
(4,3,75,5),
(5,24,30,3),
(6,6,60,8),
(7,30,25,2),
(8,1,90,20),
(9,10,45,7),
(10,4,70,12),
(11,18,35,4),
(12,5,65,9),
(13,20,30,3),
(14,2,80,15),
(15,9,50,6),
(16,3,75,14),
(17,28,20,2),
(18,7,55,10),
(19,11,40,5),
(20,6,60,9),
(21,15,35,4),
(22,8,50,6),
(23,17,30,3),
(24,2,85,18),
(25,22,25,2);

INSERT INTO subscriptions (customer_id, plan_type, monthly_charges, contract_type) 
VALUES
(1,'Basic',200,'Monthly'),
(2,'Premium',800,'Yearly'),
(3,'Basic',400,'Monthly'),
(4,'Standard',600,'Monthly'),
(5,'Basic',250,'Yearly'),
(6,'Standard',500,'Monthly'),
(7,'Basic',200,'Yearly'),
(8,'Premium',900,'Monthly'),
(9,'Standard',550,'Monthly'),
(10,'Basic',300,'Monthly'),
(11,'Standard',500,'Yearly'),
(12,'Basic',350,'Monthly'),
(13,'Basic',250,'Yearly'),
(14,'Premium',850,'Monthly'),
(15,'Standard',600,'Monthly'),
(16,'Basic',300,'Monthly'),
(17,'Basic',200,'Yearly'),
(18,'Standard',550,'Monthly'),
(19,'Standard',500,'Monthly'),
(20,'Basic',350,'Monthly'),
(21,'Standard',450,'Yearly'),
(22,'Basic',300,'Monthly'),
(23,'Basic',250,'Yearly'),
(24,'Premium',900,'Monthly'),
(25,'Basic',200,'Yearly');

INSERT INTO support_interactions (customer_id, complaints, support_calls) 
VALUES
(1,3,5),
(2,0,1),
(3,1,2),
(4,2,3),
(5,0,1),
(6,2,4),
(7,0,1),
(8,4,6),
(9,1,2),
(10,3,5),
(11,0,1),
(12,2,3),
(13,0,1),
(14,4,5),
(15,1,2),
(16,3,4),
(17,0,1),
(18,2,3),
(19,1,2),
(20,2,3),
(21,0,1),
(22,1,2),
(23,0,1),
(24,4,6),
(25,0,1);

-- --------------------
-- SELECT each Table
-- --------------------
SELECT * FROM locations;
SELECT * FROM customers;
SELECT * FROM usage_data;
SELECT * FROM subscriptions;
SELECT * FROM support_interactions;
SELECT * FROM predictions;
SELECT * FROM retention_actions;
-- -----------------------------------------------------------
-- Query for Importamt Required Features in ML Prediction
-- -----------------------------------------------------------
SELECT 
c.customer_id,
c.age,
l.city_name,
u.tenure,
u.last_login_days,
s.monthly_charges,
si.complaints
FROM customers c
JOIN locations l ON c.location_id = l.location_id
JOIN usage_data u ON c.customer_id = u.customer_id
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN support_interactions si ON c.customer_id = si.customer_id;

-- ---------------------------------------------
-- Creating Index for faster Retrieval
-- ---------------------------------------------
CREATE INDEX idx ON 
predictions(customer_id,predicted_label,prediction_time);

-- -----------------------------
-- VIEW FOR High-Risk Customers
-- -----------------------------
CREATE VIEW high_risk_customers AS
SELECT 
    c.customer_id,
    c.age,
    l.city_name,
    p.churn_probability,
    p.predicted_label,
    p.prediction_time
FROM customers c
JOIN locations l
ON c.location_id = l.location_id
JOIN predictions p
ON c.customer_id = p.customer_id
WHERE p.churn_probability >= 0.75;

-- ----------------------------------------------------
-- STORED PROCEDURE to INSERT into Predictions table
-- ----------------------------------------------------
DELIMITER $$
CREATE PROCEDURE insert_prediction(
    IN p_customer_id INT,
    IN p_churn_probability FLOAT,
    IN p_predicted_label INT
)
BEGIN
    INSERT INTO predictions(customer_id, churn_probability, predicted_label)
    VALUES (p_customer_id, p_churn_probability, p_predicted_label);
END $$
DELIMITER ;


-- -----------------------------------
-- TRIGGER for Auto-Retention Action
-- -----------------------------------
DELIMITER $$
CREATE TRIGGER auto_retention_trigger
AFTER INSERT ON predictions
FOR EACH ROW
BEGIN
    IF NEW.predicted_label = 1 THEN
        INSERT INTO retention_actions(customer_id, action_message)
        VALUES (NEW.customer_id, 'Send 20% retention discount');
    END IF;
END $$
DELIMITER ;

-- ------------------------------------
-- Churn Count Summary
-- ------------------------------------
SELECT predicted_label, COUNT(*) AS total_customers
FROM predictions
GROUP BY predicted_label;

-- -----------------------------------------
-- AVG Churn Probability according to city
-- -----------------------------------------
SELECT l.city_name, AVG(p.churn_probability) AS avg_churn_risk
FROM predictions p
JOIN customers c ON p.customer_id = c.customer_id
JOIN locations l ON c.location_id = l.location_id
GROUP BY l.city_name;

-- ---------------------------------------
-- High-Risk Customers
-- ---------------------------------------
SELECT * FROM high_risk_customers;


-- ---------
-- ---------
-- END
-- ---------
-- ---------