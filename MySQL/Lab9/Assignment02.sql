CREATE DATABASE Assignment02
GO
USE Assignment02
GO
CREATE TABLE Company (
	CompanyCode int PRIMARY KEY,
	CompanyName varchar(10),
	Address varchar(10),
	Phone char(10),
	CONSTRAINT fk_Phone CHECK (Phone NOT LIKE '&ơ^0-9]%')
)
CREATE TABLE Product (
	ProductCode int PRIMARY KEY,
	ProducName nvarchar(50),
	CompanyCode int,
	Descriptions nvarchar(60),
	Unti nvarchar(10),
	Price money,
	Amount int,
	CONSTRAINT fk_Company FOREIGN KEY (CompanyCode) REFERENCES Company(CompanyCode)
)
DROP TABLE Company
DROP TABLE Product
--2. Viết các câu lệnh để tạo các bảng như thiết kế câu 1
--3. Viết các câu lệnh để thêm dữ liệu vào các bảng
--Cho vào hai dữ liệu tưng tự như bảng đề bài trên
INSERT INTO Company VALUES
(111, 'Asus', 'Dia Chi 1', '18008198'),
(222, 'Nokia', 'Dia Chi 2', '19008198'),
(333, 'Samsung', 'Dia Chi 3', '19001221')
INSERT INTO Product VALUES
(11, N'Máy Tính T450', 111, N'Máy Nhập Cũ', N'Chiêc', 1000, 10),
(12, N'Điện Thoại Nokia 5670', 222, N'Điện Thoại Đang Hot', N'Chiêc', 200, 200),
(13, N'Máy In Samsung 450', 333, N'Máy In Loại Bình Thương', N'Chiêc', 100, 10)

--4. Viết các câu lênh truy vấn để
--a) Hiển thị tất cả các hãng sản xuất.
SELECT CompanyCode, CompanyName FROM Company
--b) Hiển thị tất cả các sản phẩm.
SELECT ProducName FROM Product

--5. Viết các câu lệnh truy vấn để
--a) Liệt kê danh sách hãng theo thứ thự ngược với alphabet của tên.
SELECT * FROM Product ORDER BY Price DESC
--b) Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần.
SELECT * FROM Company
WHERE CompanyName = 'Asus'

--6. Viết các câu lệnh truy vấn để lấy
--a) Số hãng sản phẩm mà cửa hàng có.
SELECT CompanyName FROM Company
--b) Số mặt hàng mà cửa hàng bán.
SELECT ProducName FROM Product
--c) Tổng số loại sản phẩm của mỗi hãng có trong cửa hàng.
SELECT CompanyName, ProducName, Amount FROM Company
INNER JOIN Product ON Product.CompanyCode = Company.CompanyCode
--d) Tổng số đầu sản phẩm của toàn cửa hàng
SELECT SUM(Amount) AS N'Tổng Sản Phẩm' FROM Product

--7. Thay đổi những thay đổi sau trên cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0).
ALTER TABLE Product ADD CONSTRAINT fk_money CHECK(Price > 0)
--b) Viết câu lệnh để thay đổi số điện thoại phải bắt đầu bằng 0.
ALTER TABLE Product ADD CONSTRAINT fk_Phone CHECK(Phone NOT LIKE '&ơ^0-9]%')
--c) Viết các câu lệnh để xác định các khóa ngoại và khóa chính của các bảng.
ALTER TABLE Product ADD CONSTRAINT fk_Company FOREIGN KEY (CompanyCode) REFERENCES Company(CompanyCode)

--8. Thực hiện các yêu cầu sau
--a) Thiết lập chỉ mục (Index) cho các cột sau: Tên hàng và Mô tả hàng để tăng hiệu suất truy vấn
--dữ liệu từ 2 cột này
CREATE INDEX IX_Company_Product ON Product(ProducName, Descriptions)
--b) Viết các View sau:
	--◦ View_SanPham: với các cột Mã sản phẩm, Tên sản phẩm, Giá bán
CREATE VIEW View_SanPham_TenSanPham_GiaBan AS
SELECT ProductCode, ProducName, Amount FROM Product
SELECT * FROM View_SanPham_TenSanPham_GiaBan
	--◦ View_SanPham_Hang: với các cột Mã SP, Tên sản phẩm, Hãng sản xuất
CREATE VIEW View_MaSP_TenSP_HangSanXuat AS
SELECT ProductCode, ProducName, CompanyName FROM Product

SELECT * FROM View_MaSP_TenSP_HangSanXuat
--c) Viết các Store Procedure sau:
	--◦ SP_SanPham_TenHang: Liệt kê các sản phẩm với tên hãng truyền vào store
CREATE PROCEDURE SP_SanPham_TenHang AS
SELECT CompanyName, ProducName FROM Product
INNER JOIN Product ON Product.CompanyCode = Company.CompanyCode
EXEC SP_SanPham_TenHang

--◦ SP_SanPham_Gia: Liệt kê các sản phẩm có giá bán lớn hơn hoặc bằng giá bán truyền
--vào
CREATE PROCEDURE SP_SanPham_Gia AS
SELECT ProductName, Descriptions, Price FROM Product
WHERE Price >= 1000

--◦ SP_SanPham_HetHang: Liệt kê các sản phẩm đã hết hàng (số lượng = 0)
CREATE PROC SP_SanPham_HetHang AS
SELECT * View_MaSP_TenSP_HangSanXuat

--d) Viết Trigger sau: 
	--◦ TG_Xoa_Hang: Ngăn không cho xóa hãng
CREATE TRIGGER TG_Xoa_Hang ON Product FOR DELETE
AS
IF EXISTS (SELECT CompanyName FROM Company) 
BEGIN
	PRINT 'K Dc Xoa'
	ROLLBACK TRAN
END
	--◦ TG_Xoa_SanPham: Chỉ cho phép xóa các sản phẩm đã hết hàng (số lượng = 0)
CREATE TRIGGER TG_Xoa_SanPham ON Product FOR DELETE
AS
IF EXISTS (SELECT Amount FROM DELETED)
DELETE FROM Amount
WHERE Amount = 0
ELSE
BEGIN
PRINT 'ERRO'
ROLLBACK TRAN
END
SELECT * FROM Company
SELECT * FROM Product