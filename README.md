# 📦 Đồ án Kho Dữ liệu: Xây dựng Kho Dữ liệu Phục vụ Phân tích Bán hàng từ CRM & ERP

Đây là đồ án kết thúc môn học **Kho dữ liệu** (Mã học phần: `242DAWH430784_02`) tại Trường Đại học Sư phạm Kỹ thuật TP. Hồ Chí Minh.

---

## 📝 Tổng quan

Dự án tập trung vào việc xây dựng một hệ thống **Kho dữ liệu (Data Warehouse)** hoàn chỉnh để phân tích dữ liệu bán hàng được tích hợp từ hai nguồn chính:  
- **CRM (Quản lý Quan hệ Khách hàng)**  
- **ERP (Hoạch định Tài nguyên Doanh nghiệp)**  

Mục tiêu là biến đổi dữ liệu thô, phân tán thành một nguồn dữ liệu **tập trung, sạch sẽ, có cấu trúc**, sẵn sàng cho việc **phân tích kinh doanh**, **tạo báo cáo** và **trực quan hóa**.

---

## 🎯 Mục tiêu chính

- **Thiết kế Kiến trúc Medallion**  
  Tổ chức dữ liệu qua ba tầng (**Bronze - Silver - Gold**) để đảm bảo chất lượng, khả năng truy vết và tái sử dụng.

- **Xây dựng quy trình ETL**  
  Thực hiện quá trình **Extract - Transform - Load** bằng hai phương pháp:  
  - T-SQL  
  - SSIS (SQL Server Integration Services)

- **Mô hình hóa dữ liệu**  
  Thiết kế kho dữ liệu ở tầng **Gold** theo mô hình **Star Schema** tối ưu cho truy vấn phân tích.

- **Phân tích đa chiều**  
  Tạo khối dữ liệu (**Data Cube**) bằng **SSAS (SQL Server Analysis Services)**, cho phép phân tích theo các chiều thời gian, sản phẩm, khách hàng.

- **Trực quan hóa dữ liệu**  
  Sử dụng **Power BI** để xây dựng dashboard tương tác, theo dõi KPIs và hỗ trợ ra quyết định.

---

## 🏛️ Kiến trúc Hệ thống

Dự án áp dụng **Kiến trúc Medallion**, gồm 3 tầng:

- 🥉 **Tầng Bronze (Raw Data)**  
  Lưu trữ dữ liệu **thô** từ các file CSV của CRM và ERP, đóng vai trò bản sao của nguồn, phục vụ phục hồi và kiểm tra.

- 🥈 **Tầng Silver (Cleansed & Standardized Data)**  
  Dữ liệu được **làm sạch, chuẩn hóa** (đổi tên cột, xử lý thiếu, chuẩn kiểu dữ liệu) và tích hợp.

- 🥇 **Tầng Gold (Business-Ready Data)**  
  Dữ liệu được **tổng hợp và mô hình hóa** theo **Star Schema**, sẵn sàng cho phân tích và báo cáo.

---

## 🛠️ Công nghệ sử dụng

- **Cơ sở dữ liệu**: Microsoft SQL Server  
- **ETL**: SSIS (SQL Server Integration Services), T-SQL  
- **Mô hình hóa & Phân tích**: SSAS (SQL Server Analysis Services)  
- **Trực quan hóa**: Power BI  

---

## ✨ Chức năng chính

- **Tích hợp dữ liệu** từ CRM và ERP: khách hàng, sản phẩm, đơn hàng.
- **Làm sạch & chuẩn hóa**: xử lý thiếu, sai định dạng, hợp nhất.
- **Xây dựng Dimensions & Fact Tables**:  
  - Dimensions: `dim_customers`, `dim_products`, `dim_dates`  
  - Fact Table: `fact_sales`
- **Phân tích đa chiều (OLAP Cube)**: slice, dice, drill-down.
- **Báo cáo tương tác** trên Power BI:  
  - Doanh thu  
  - Số lượng bán  
  - Hiệu suất sản phẩm  
  - Phân tích khách hàng theo khu vực

---

## 🧑‍💻 Đội ngũ phát triển

| Họ và Tên               | MSSV       |
|-------------------------|------------|
| Nguyễn Thị Ngọc Hân (Nhóm trưởng) | 22133017 |
| Nguyễn Công Đôn         | 22133013   |
| Nguyễn Hoàng            | 22133020   |
| Nguyễn Quốc Huy         | 22133026   |
| Nguyễn Minh Quang       | 22133045   |

**Giảng viên hướng dẫn**: ThS. Nguyễn Văn Thành

---

