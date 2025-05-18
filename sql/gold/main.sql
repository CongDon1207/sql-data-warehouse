-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.customer_id) AS customer_key, -- Surrogate key
    ci.customer_id,
    ci.customer_crm_id,
    ci.firstname,
    ci.lastname,
    la.customer_country,
    ci.marital_status,
    CASE 
        WHEN ci.gender != 'n/a' THEN ci.gender  -- CRM is the primary source for gender
        ELSE ISNULL(ca.gender, 'n/a')  			-- Fallback to ERP data
    END AS gender,
    ca.birthday,
    ci.join_crm_date
FROM silver.crm_customers ci
LEFT JOIN silver.erp_customer_demographic ca
    ON ci.customer_id = ca.customer_id
LEFT JOIN silver.erp_customer_location la
    ON ci.customer_id = la.customer_id;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pro.product_id, pro.start_date, pro.end_date) AS product_key, -- Surrogate key
    product_id,
	product_crm_id,
	product_name,
	pro.category_id,
	category_name,
	subcategory_name,
	maintenance_flag,
	product_cost,
	product_line,
	start_date,
	end_date
FROM silver.crm_products pro
LEFT JOIN silver.erp_categories cate
    ON pro.category_id = cate.category_id
GO

-- =============================================================================
-- Create Dimension: gold.dim_dates
-- =============================================================================
CREATE TABLE gold.dim_dates (
    date_id            DATE PRIMARY KEY,
    day                INT,
    month              INT,
    year               INT,
    quarter            INT,
    day_of_week        INT,  -- 1 = Sunday, 7 = Saturday (by default)
    day_name           NVARCHAR(10),
    month_name         NVARCHAR(10),
    is_weekend         BIT,
);

DECLARE @start_date DATE;
DECLARE @end_date DATE;

SELECT @start_date = MIN(order_date), @end_date = DATEADD(YEAR, 1, MAX(due_date))
FROM silver.crm_sales_details;

WHILE @start_date <= @end_date
BEGIN
    INSERT INTO gold.dim_dates (
        date_id,
        day,
        month,
        year,
        quarter,
        day_of_week,
        day_name,
        month_name,
        is_weekend
    )
    SELECT
        @start_date,
        DAY(@start_date),
        MONTH(@start_date),
        YEAR(@start_date),
        DATEPART(QUARTER, @start_date),
        DATEPART(WEEKDAY, @start_date),
        DATENAME(WEEKDAY, @start_date),
        DATENAME(MONTH, @start_date),
        CASE WHEN DATEPART(WEEKDAY, @start_date) IN (1, 7) THEN 1 ELSE 0 END;
    SET @start_date = DATEADD(DAY, 1, @start_date);
END;

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    order_id,
	product_key,
	customer_key,
	order_date,
	ship_date,
	due_date,
	price,
	quantity,
	total_amount
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pro
    ON sd.product_id = pro.product_id
LEFT JOIN gold.dim_customers cust
    ON sd.customer_crm_id = cust.customer_crm_id;
GO
