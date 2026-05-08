-- ===================================================
-- DDL: CREATE TABLES (FAMS - based on ER Diagram)
-- ===================================================

CREATE TABLE LOCATION (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE CLIENT (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_ref INT,
    tax_bracket VARCHAR(50),
    investment_experience_level VARCHAR(50)
);

CREATE TABLE VENDORS (
    vendor_phone VARCHAR(15) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    vendor_email VARCHAR(150) UNIQUE,
    contact_info TEXT,
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES CLIENT(client_id)
);

CREATE TABLE SCRAP_YARD (
    scrap_yard_id INT PRIMARY KEY AUTO_INCREMENT,
    acqup_date DATE,
    cost DECIMAL(15,2),
    location VARCHAR(255)
);

CREATE TABLE ASSET (
    asset_id INT PRIMARY KEY AUTO_INCREMENT,
    asset_name VARCHAR(150) NOT NULL,
    serial_number VARCHAR(100) UNIQUE,
    model_number VARCHAR(100),
    manufacturer VARCHAR(150),
    is_operational BOOLEAN DEFAULT TRUE,
    purchase_date DATE,
    scrap_yard_id INT,
    FOREIGN KEY (scrap_yard_id) REFERENCES SCRAP_YARD(scrap_yard_id)
);

CREATE TABLE DISPOSAL (
    disposal_id INT PRIMARY KEY AUTO_INCREMENT,
    disposal_date DATE NOT NULL,
    reason TEXT,
    price DECIMAL(15,2),
    serial_number VARCHAR(100),
    asset_id INT,
    FOREIGN KEY (asset_id) REFERENCES ASSET(asset_id)
);

CREATE TABLE DEPRECIATION (
    depri_id INT PRIMARY KEY AUTO_INCREMENT,
    method VARCHAR(80) NOT NULL,
    rate DECIMAL(5,2),
    current_value DECIMAL(15,2),
    dep_date DATE,
    asset_id INT,
    asset_value_snapshot DECIMAL(15,2),
    location_id INT,
    FOREIGN KEY (asset_id) REFERENCES ASSET(asset_id),
    FOREIGN KEY (location_id) REFERENCES LOCATION(location_id)
);

CREATE TABLE SUB_PORTFOLIO (
    sub_portfolio_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    po_date DATE,
    vendor_email VARCHAR(150),
    asset_id INT,
    scrap_yard_id INT,
    FOREIGN KEY (asset_id) REFERENCES ASSET(asset_id),
    FOREIGN KEY (scrap_yard_id) REFERENCES SCRAP_YARD(scrap_yard_id)
);

CREATE TABLE PORTFOLIO (
    portfolio_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    type VARCHAR(80),
    manager VARCHAR(150),
    sub_portfolio_id INT,
    client_id INT,
    FOREIGN KEY (sub_portfolio_id) REFERENCES SUB_PORTFOLIO(sub_portfolio_id),
    FOREIGN KEY (client_id) REFERENCES CLIENT(client_id)
);

CREATE TABLE PURCHASE_ORDER (
    po_id INT PRIMARY KEY AUTO_INCREMENT,
    po_date DATE NOT NULL,
    purchase_date DATE,
    vendor_phone VARCHAR(15),
    vendor_email VARCHAR(150),
    asset_id INT,
    portfolio_id INT,
    FOREIGN KEY (vendor_phone) REFERENCES VENDORS(vendor_phone),
    FOREIGN KEY (asset_id) REFERENCES ASSET(asset_id),
    FOREIGN KEY (portfolio_id) REFERENCES PORTFOLIO(portfolio_id)
);

CREATE TABLE FINANCIAL_ACCOUNT (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    currency VARCHAR(10) DEFAULT 'INR',
    status VARCHAR(20) DEFAULT 'Active',
    asset_id INT,
    portfolio_id INT,
    FOREIGN KEY (asset_id) REFERENCES ASSET(asset_id),
    FOREIGN KEY (portfolio_id) REFERENCES PORTFOLIO(portfolio_id)
);

CREATE TABLE TRANSACTION (
    txn_id INT PRIMARY KEY AUTO_INCREMENT,
    txn_date DATE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    type ENUM('CREDIT','DEBIT') NOT NULL,
    description TEXT,
    account_id INT,
    FOREIGN KEY (account_id) REFERENCES FINANCIAL_ACCOUNT(account_id)
);

-- ===================================================
-- DML: INSERT SAMPLE DATA
-- ===================================================

INSERT INTO LOCATION (name, address, city, state, country) VALUES
('Head Office', '12 MG Road', 'Mumbai', 'Maharashtra', 'India'),
('South Branch', '45 Anna Salai', 'Chennai', 'Tamil Nadu', 'India'),
('North Warehouse', '7 Industrial Zone', 'Delhi', 'Delhi', 'India'),
('West Depot', '88 MIDC Area', 'Pune', 'Maharashtra', 'India'),
('East Hub', '33 Salt Lake Sector', 'Kolkata', 'West Bengal', 'India');

INSERT INTO CLIENT (client_ref, tax_bracket, investment_experience_level) VALUES
(NULL, '30%', 'Expert'),
(NULL, '20%', 'Intermediate'),
(NULL, '10%', 'Novice'),
(NULL, '30%', 'Expert'),
(NULL, '20%', 'Intermediate');

INSERT INTO VENDORS (vendor_phone, name, vendor_email, contact_info, client_id)
VALUES
('9876543210', 'Dell Technologies India', 'dell@vendor.com', 'Bengaluru HQ', 1),
('9123456789', 'HP India Ltd', 'hp@vendor.com', 'Mumbai Office', 2),
('9988776655', 'Godrej Interio', 'godrej@vendor.com', 'Pune Plant', 3),
('9001122334', 'Tata Motors Ltd', 'tata@vendor.com', 'Chennai Plant', 4),
('9876001234', 'Lenovo India', 'lenovo@vendor.com', 'Hyderabad Hub', 5);

INSERT INTO SCRAP_YARD (acqup_date, cost, location) VALUES
('2023-01-10', 5000.00, 'Bhiwandi Scrap Zone, Mumbai'),
('2023-06-15', 3200.00, 'Manali Industrial Scrap, Chennai'),
('2024-02-20', 7800.00, 'Okhla Scrap Market, Delhi'),
('2024-05-01', 2500.00, 'Pimpri Scrap Yard, Pune'),
('2024-09-10', 4100.00, 'Howrah Metals, Kolkata');

INSERT INTO ASSET (asset_name, serial_number, model_number, manufacturer, is_operational, purchase_date)
VALUES
('Dell Latitude 5540 Laptop', 'SN-DL-001', 'LAT5540', 'Dell', TRUE, '2022-05-10'),
('HP LaserJet Pro Printer', 'SN-HP-002', 'LJPRO400', 'HP', TRUE, '2021-03-22'),
('Godrej Executive Desk', 'SN-GJ-003', 'GED-2020', 'Godrej', TRUE, '2020-01-15'),
('Tata Indica Company Car', 'SN-TM-004', 'INDICA-V2', 'Tata', FALSE, '2019-07-05'),
('Lenovo ThinkPad X1 Carbon', 'SN-LV-005', 'TPX1C', 'Lenovo', TRUE, '2023-02-28');

INSERT INTO DISPOSAL (disposal_date, reason, price, serial_number, asset_id)
VALUES
('2024-01-15', 'End of life - 5 year cycle', 15000.00, 'SN-TM-004', 4);

INSERT INTO DEPRECIATION (method, rate, current_value, dep_date, asset_id, asset_value_snapshot, location_id)
VALUES
('Straight-Line', 20.00, 68000.00, '2024-05-10', 1, 85000.00, 1),
('Straight-Line', 25.00, 18000.00, '2024-03-22', 2, 30000.00, 2),
('Reducing Balance', 10.00, 18000.00, '2024-01-15', 3, 25000.00, 4);

INSERT INTO SUB_PORTFOLIO (name, po_date, vendor_email, asset_id)
VALUES
('IT Equipment - Laptops', '2022-05-01', 'dell@vendor.com', 1),
('Office Printing', '2021-03-01', 'hp@vendor.com', 2),
('Furniture Assets', '2020-01-01', 'godrej@vendor.com', 3);

INSERT INTO PORTFOLIO (name, type, manager, sub_portfolio_id, client_id)
VALUES
('Fixed Assets Portfolio', 'Fixed Asset', 'Aakash Sharma', 1, 1),
('Office Infrastructure', 'Infrastructure', 'Meera Patel', 2, 2),
('IT Assets Portfolio', 'IT Equipment', 'Rohan Verma', 3, 3);

INSERT INTO PURCHASE_ORDER (po_date, purchase_date, vendor_phone, vendor_email, asset_id, portfolio_id)
VALUES
('2022-05-01', '2022-05-10', '9876543210', 'dell@vendor.com', 1, 1),
('2021-03-01', '2021-03-22', '9123456789', 'hp@vendor.com', 2, 2),
('2020-01-01', '2020-01-15', '9988776655', 'godrej@vendor.com', 3, 3);

INSERT INTO FINANCIAL_ACCOUNT (name, balance, currency, status, asset_id, portfolio_id)
VALUES
('Dell Laptop Account', 85000.00, 'INR', 'Active', 1, 1),
('HP Printer Account', 30000.00, 'INR', 'Active', 2, 2),
('Godrej Furniture Acct', 25000.00, 'INR', 'Active', 3, 3);

INSERT INTO TRANSACTION (txn_date, amount, type, description, account_id)
VALUES
('2022-05-10', 85000.00, 'DEBIT', 'Initial purchase - Dell Laptop', 1),
('2021-03-22', 30000.00, 'DEBIT', 'Initial purchase - HP Printer', 2),
('2020-01-15', 25000.00, 'DEBIT', 'Initial purchase - Godrej Desk', 3);

-- ===================================================
-- SQL QUERIES
-- ===================================================

SELECT * FROM ASSET;

SELECT * FROM PORTFOLIO;

SELECT * FROM FINANCIAL_ACCOUNT;

SELECT a.asset_name, a.serial_number, p.name AS portfolio_name
FROM ASSET a
JOIN PORTFOLIO p ON p.portfolio_id = a.asset_id;

SELECT fa.name AS account_name,
SUM(t.amount) AS total_transactions
FROM FINANCIAL_ACCOUNT fa
JOIN TRANSACTION t ON fa.account_id = t.account_id
GROUP BY fa.name;

SELECT a.asset_name, d.current_value
FROM ASSET a
JOIN DEPRECIATION d ON a.asset_id = d.asset_id
WHERE d.current_value < (
    SELECT AVG(current_value) FROM DEPRECIATION
);

-- ===================================================
-- VIEWS
-- ===================================================

CREATE VIEW vw_asset_full_profile AS
SELECT
    a.asset_id,
    a.asset_name,
    a.serial_number,
    a.manufacturer,
    a.is_operational,
    d.method,
    d.current_value,
    l.city,
    v.name AS vendor_name
FROM ASSET a
LEFT JOIN DEPRECIATION d ON a.asset_id = d.asset_id
LEFT JOIN LOCATION l ON d.location_id = l.location_id
LEFT JOIN PURCHASE_ORDER po ON a.asset_id = po.asset_id
LEFT JOIN VENDORS v ON po.vendor_phone = v.vendor_phone;

CREATE VIEW vw_portfolio_financial_summary AS
SELECT
    p.portfolio_id,
    p.name AS portfolio_name,
    SUM(fa.balance) AS total_balance
FROM PORTFOLIO p
LEFT JOIN FINANCIAL_ACCOUNT fa
ON p.portfolio_id = fa.portfolio_id
GROUP BY p.portfolio_id, p.name;