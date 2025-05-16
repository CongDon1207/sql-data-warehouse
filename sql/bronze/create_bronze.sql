USE dwh_nhom_1;
GO

-- BẢNG KHÁCH HÀNG CRM (cust_info.csv)
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(10),
    cst_gndr            NVARCHAR(10),
    cst_create_date     DATETIME
);
GO

-- BẢNG SẢN PHẨM CRM (prd_info.csv)
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(100),
    prd_cost     FLOAT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO

-- BẢNG GIAO DỊCH BÁN HÀNG CRM (sales_details.csv)
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num   NVARCHAR(50),
    sls_prd_key   NVARCHAR(50),
    sls_cust_id   INT,
    sls_order_dt  INT,          
    sls_ship_dt   INT,
    sls_due_dt    INT,
    sls_sales     INT,
    sls_quantity  INT,
    sls_price     INT
);
GO


-- BẢNG DANH MỤC NHÓM SẢN PHẨM ERP (PX_CAT_G1V2.csv)
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(100),
    subcat       NVARCHAR(100),
    maintenance  NVARCHAR(10)
);
GO

-- BẢNG THÔNG TIN ĐỊA LÝ KHÁCH HÀNG ERP (LOC_A101.csv)
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(100)
);
GO

-- BẢNG NHÂN KHẨU HỌC KHÁCH HÀNG ERP (CUST_AZ12.csv)
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATETIME,
    gen    NVARCHAR(10)
);
GO