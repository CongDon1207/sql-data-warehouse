CREATE DATABASE BronzeDB;
USE BronzeDB;

--CRM Customer Table;
CREATE TABLE crm_cust_info (
    cst_id INT NULL,
    cst_key NVARCHAR(50) NULL,
    cst_firstname NVARCHAR(50) NULL,
    cst_lastname NVARCHAR(50) NULL,
    cst_marital_status NVARCHAR(10) NULL,
    cst_gndr NVARCHAR(10) NULL,
    cst_create_date DATETIME NULL
);

--CRM Product Table
CREATE TABLE crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(50) NULL,
    prd_nm NVARCHAR(100) NULL,
    prd_cost FLOAT NULL,
    prd_line NVARCHAR(50) NULL,
    prd_start_dt DATETIME NULL,
    prd_end_dt DATETIME NULL
);

--CRM Sales Table
CREATE TABLE crm_sales_details (
    sls_ord_num NVARCHAR(50) NULL,
    sls_prd_key NVARCHAR(50) NULL,
    sls_cust_id INT NULL,
    sls_order_dt INT NULL,
    sls_ship_dt INT NULL,
    sls_due_dt INT NULL,
    sls_sales INT NULL,
    sls_quantity INT NULL,
    sls_price INT NULL
);

--ERP Customer Table
CREATE TABLE erp_cust (
    cid NVARCHAR(50) NULL,
    bdate DATETIME NULL,
    gen NVARCHAR(10) NULL
);

--ERP Product Extension Category 
CREATE TABLE erp_px_cat (
    id NVARCHAR(50) NULL,
    cat NVARCHAR(100) NULL,
    subcat NVARCHAR(100) NULL,
    maintenance NVARCHAR(10) NULL
);

--ERP Location
CREATE TABLE erp_loc(
    cid NVARCHAR(50) NULL,
    cntry NVARCHAR(100) NULL
);
USE BronzeDB;

SELECT  * FROM crm_cust_info;
SELECT count (*) FROM crm_cust_info;

SELECT * FROM crm_prd_info;
SELECT count (*) FROM crm_prd_info;

SELECT * FROM crm_sales_details;
select count (*) from crm_sales_details;

SELECT * FROM erp_cust;
SELECT count (*) FROM erp_cust;

SELECT * FROM erp_px_cat;
SELECT count (*) FROM erp_px_cat;

SELECT * FROM erp_loc;
SELECT count (*) FROM erp_loc;

