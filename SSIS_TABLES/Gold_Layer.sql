Create Database Gold_SSIS
USE Gold_SSIS;

CREATE TABLE Fact_Sales (
    sales_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_key INT,
    product_key INT,
    date_key INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

CREATE TABLE Dim_Customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_fullname NVARCHAR(100),
    cst_marital_status NVARCHAR(10),
    cst_gndr NVARCHAR(10),
    cst_birth_date DATETIME,
    country NVARCHAR(100)
);

CREATE TABLE Dim_Product (
    product_key INT IDENTITY(1,1) PRIMARY KEY,
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(100),
    prd_cost FLOAT,
    prd_line NVARCHAR(50),
    cat NVARCHAR(100),
    subcat NVARCHAR(100)
);

CREATE TABLE Dim_Date (
    date_key INT PRIMARY KEY,
    full_date DATETIME,
    year INT,
    quarter INT,
    month INT,
    day INT
);


USE Gold_SSIS;

SELECT * FROM dbo.Dim_Customer
SELECT count (*) FROM dbo.Dim_Customer

SELECT * FROM dbo.Dim_Product
SELECT count (*) FROM dbo.Dim_Product

SELECT * FROM dbo.Dim_Date
SELECT count (*) FROM dbo.Dim_Date

SELECT * FROM dbo.Fact_Sales
SELECT count (*) FROM dbo.Fact_Sales