CREATE DATABASE SilverSSIS;
USE SilverSSIS;

SELECT name
FROM sys.tables;

CREATE TABLE crm_cust_info (
    cst_id INT NOT NULL PRIMARY KEY,
    cst_key NVARCHAR(50) NOT NULL UNIQUE,
    cst_firstname NVARCHAR(50) NULL,
    cst_lastname NVARCHAR(50) NULL,
    cst_marital_status NVARCHAR(10) NULL,
    cst_gndr NVARCHAR(10) NULL,
    cst_create_date DATETIME NULL
);

CREATE TABLE crm_prd_info (
    prd_id INT NOT NULL PRIMARY KEY,
    prd_key NVARCHAR(50) NOT NULL UNIQUE,
    prd_nm NVARCHAR(100) NOT NULL,
    prd_cost FLOAT NULL,
    prd_line NVARCHAR(50) NULL,
    prd_start_dt DATETIME NULL,
    prd_end_dt DATETIME NULL,
);

CREATE TABLE crm_sales_details (
    sls_ord_num NVARCHAR(50) NOT NULL PRIMARY KEY,
    sls_prd_key NVARCHAR(50) NOT NULL,
    sls_cust_id INT NOT NULL,
    sls_order_dt DATETIME NULL,		
    sls_ship_dt DATETIME NULL,
    sls_due_dt DATETIME NULL,
    sls_sales INT NULL,
    sls_quantity INT NULL,
    sls_price INT NULL,
    CONSTRAINT FK_sales_cust FOREIGN KEY (sls_cust_id) REFERENCES crm_cust_info(cst_id),
    CONSTRAINT FK_sales_product FOREIGN KEY (sls_prd_key) REFERENCES crm_prd_info(prd_key)
);

CREATE TABLE erp_cust (
    cid NVARCHAR(50) NOT NULL,
    bdate DATETIME NULL,
    gen NVARCHAR(10) NULL,
    CONSTRAINT FK_erp_cust_crm FOREIGN KEY (cid) REFERENCES crm_cust_info(cst_key)
);

CREATE TABLE erp_px_cat (
    id NVARCHAR(50) NOT NULL PRIMARY KEY,
    cat NVARCHAR(100) NOT NULL,
    subcat NVARCHAR(100) NOT NULL,
    maintenance NVARCHAR(10) NULL
);

CREATE TABLE erp_loc (
    cid NVARCHAR(50) NOT NULL,
    cntry NVARCHAR(100) NULL,
    CONSTRAINT FK_erp_loc_crm FOREIGN KEY (cid) REFERENCES crm_cust_info(cst_key)
);


USE SilverSSIS;
SELECT * FROM crm_cust_info
SELECT count (*) FROM crm_cust_info;

SELECT * FROM crm_prd_info;
SELECT count (*) FROM crm_prd_info;

SELECT * FROM crm_sales_details;
SELECT count (*) FROM crm_sales_details;

SELECT * FROM erp_cust;
SELECT Count (*) FROM erp_cust

SELECT * FROM erp_loc;
SELECT Count (*) FROM erp_loc

SELECT * FROM erp_px_cat;
SELECT count (*) from erp_px_cat
