use dwh_nhom_1;
go

select top(5) prd_key
from bronze.crm_prd_info;

select top(5) sls_prd_key
from bronze.crm_sales_details;

select top(5) id
from bronze.erp_px_cat_g1v2;

select DISTINCT prd_line
from bronze.crm_prd_info;

select prd_nm 
from bronze.crm_prd_info
where prd_line = 'S';

select min(sls_order_dt), max(sls_order_dt)
from bronze.crm_sales_details;

select top(5) cst_key
from bronze.crm_cust_info;

select top(5) cid
from bronze.erp_loc_a101;

select top(100) cid
from bronze.erp_cust_az12;

select cid
from bronze.erp_cust_az12
where cid not like 'AW%' AND cid not like 'NAS%'

select distinct cntry
from bronze.erp_loc_a101;

