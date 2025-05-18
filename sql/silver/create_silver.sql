USE dwh_nhom_1;
GO

IF OBJECT_ID('silver.crm_customers', 'U') IS NOT NULL
    DROP TABLE silver.crm_customers;
GO

CREATE TABLE silver.crm_customers (
    customer_crm_id     INT,
    customer_id			NVARCHAR(50),
    firstname			NVARCHAR(50),
    lastname			NVARCHAR(50),
    marital_status		NVARCHAR(50),
    gender				NVARCHAR(50),
    join_crm_date		DATE,
    record_inserted_at  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_products', 'U') IS NOT NULL
    DROP TABLE silver.crm_products;
GO

CREATE TABLE silver.crm_products (
    product_crm_id		INT,
    product_id			NVARCHAR(50),
    category_id			NVARCHAR(50),
    product_name		NVARCHAR(50),
    product_cost		INT,
    product_line		NVARCHAR(50),
    start_date			DATE,
    end_date			DATE,
    record_inserted_at	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    order_id			NVARCHAR(50),
    product_id			NVARCHAR(50),
    customer_crm_id		INT,
    order_date			DATE,
    ship_date			DATE,
    due_date			DATE,
    quantity			INT,
    price				INT,
    total_amount		INT,
    record_inserted_at	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_customer_location', 'U') IS NOT NULL
    DROP TABLE silver.erp_customer_location;
GO

CREATE TABLE silver.erp_customer_location (
    customer_id         NVARCHAR(50),
    customer_country    NVARCHAR(50),
    record_inserted_at	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_customer_demographic', 'U') IS NOT NULL
    DROP TABLE silver.erp_customer_demographic;
GO

CREATE TABLE silver.erp_customer_demographic (
    customer_id        NVARCHAR(50),
    birthday           DATE,
    gender             NVARCHAR(50),
    record_inserted_at DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_categories', 'U') IS NOT NULL
    DROP TABLE silver.erp_categories;
GO

CREATE TABLE silver.erp_categories (
    category_id         NVARCHAR(50),
    category_name       NVARCHAR(50),
    subcategory_name    NVARCHAR(50),
    maintenance_flag	BIT,
    record_inserted_at	DATETIME2 DEFAULT GETDATE()
);
GO

