/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
EXEC silver.load_silver;
USE dwh_nhom_1;
GO
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		-- Loading silver.crm_customers
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_customers';
		TRUNCATE TABLE silver.crm_customers;
		PRINT '>> Inserting Data Into: silver.crm_customers';

		INSERT INTO silver.crm_customers (
			customer_crm_id, 
			customer_id, 
			firstname, 
			lastname, 
			marital_status, 
			gender,
			join_crm_date
		)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname),
			TRIM(cst_lastname),
			CASE 
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				ELSE 'n/a'
			END AS marital_status, -- Normalize marital status values to readable format
			CASE 
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'n/a'
			END AS gender, -- Normalize gender values to readable format
			cst_create_date
		FROM (
			SELECT
				*,
				ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last -- Assigns a unique row number (start from 1) to each row within the same cst_id group, ordered by cst_create_date
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		) t
		WHERE flag_last = 1; -- Select the most recent record per customer

		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.crm_products
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_products';
		TRUNCATE TABLE silver.crm_products;
		PRINT '>> Inserting Data Into: silver.crm_products';

		INSERT INTO silver.crm_products (
			product_crm_id,
			product_id,
			category_id,
			product_name,
			product_cost,
			product_line,
			start_date,
			end_date
		)
		SELECT
			prd_id,
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS product_id,        -- Extract product key
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS category_id, -- Extract category ID
			prd_nm,
			ISNULL(prd_cost, 0) AS product_cost,
			CASE 
				WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS product_line, -- Map product line codes to descriptive values
			CAST(prd_start_dt AS DATE) AS start_date,
			CAST(
				LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
				AS DATE
			) AS end_date -- Calculate end date as one day before the next start date of the next version
		FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading crm_sales_details
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting Data Into: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			order_id,
			product_id,
			customer_crm_id,
			order_date,
			ship_date,
			due_date,
			total_amount,
			quantity,
			price
		)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS order_date,
			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS shipe_date,
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS due_date,
			CASE 
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
					THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS total_amount, -- Recalculate sales if original value is missing or incorrect
			sls_quantity,
			CASE 
				WHEN sls_price IS NULL OR sls_price <= 0 
					THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price  -- Derive price if original value is invalid
			END AS price
		FROM bronze.crm_sales_details;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

        -- Loading silver.erp_customer_location
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_customer_location';
		TRUNCATE TABLE silver.erp_customer_location;
		PRINT '>> Inserting Data Into: silver.erp_customer_location';
		INSERT INTO silver.erp_customer_location (
			customer_id,
			customer_country
		)
		SELECT
			REPLACE(cid, '-', '') AS customer_id, 
			CASE
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
				ELSE TRIM(cntry)
			END AS customer_country -- Normalize and Handle missing or blank country codes
		FROM bronze.erp_loc_a101;

	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.erp_customer_demographic
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_customer_demographic';
		TRUNCATE TABLE silver.erp_customer_demographic;
		PRINT '>> Inserting Data Into: silver.erp_customer_demographic';
		INSERT INTO silver.erp_customer_demographic (
			customer_id,
			birthday,
			gender
		)
		SELECT
			CASE
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- Remove 'NAS' prefix if present
				ELSE cid
			END AS customer_id, 
			CASE
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS birthday, -- Set future birthdates to NULL
			CASE
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gender -- Normalize gender values and handle unknown cases
		FROM bronze.erp_cust_az12;

	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.erp_categories
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_categories';
		TRUNCATE TABLE silver.erp_categories;
		PRINT '>> Inserting Data Into: silver.erp_categories';
		INSERT INTO silver.erp_categories (
			category_id,
			category_name,
			subcategory_name,
			maintenance_flag
		)
		SELECT
			id,
			cat,
			subcat,
			CASE 
				WHEN UPPER(TRIM(maintenance)) = 'YES' THEN 1
				ELSE 0
			END AS maintenance_flag
		FROM bronze.erp_px_cat_g1v2;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
