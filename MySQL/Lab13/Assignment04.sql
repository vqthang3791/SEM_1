CREATE DATABASE Assignment04
GO
USE Assignment04
GO
CREATE TABLE LoaiSanPham (
	MaSP varchar(10) PRIMARY KEY,
	TenLoaiSP nvarchar(50),
)
CREATE TABLE NguoiChiuTrachNhiem (
	IDNCTN int PRIMARY KEY,
	TenNCTN nvarchar(50),
)
CREATE TABLE SanPham (
	IDSP varchar(20) PRIMARY KEY,
	TenSP nvarchar(50),
	MaSP varchar(10),
	NgayXS datetime,
	IDNCTN int,
	CONSTRAINT fk_LoaiSP FOREIGN KEY (MaSP) REFERENCES LoaiSanPham(MaSP),
	CONSTRAINT fk_NCTN FOREIGN KEY (IDNCTN) REFERENCES NguoiChiuTrachNhiem(IDNCTN)
)
DROP TABLE LoaiSanPham
DROP TABLE NguoiChiuTrachNhiem
DROP TABLE SanPham
INSERT INTO LoaiSanPham VALUES
('Z37', N'Máy tính sách tay'),
('2', N'Sản Phâm 2'),
('3', N'Sản Phẩm 3'),
('4', N'Sản Phẩm 4'),
('5', N'Sản Phẩm 5')
INSERT INTO NguoiChiuTrachNhiem VALUES
(222, N'Nguyễn Văn An'),
(333, N'Người Chịu Trách Nhiệm 1'),
(444, N'Người Chịu Trách Nhiệm 2'),
(555, N'Người Chịu Trách Nhiệm 3'),
(666, N'Người Chịu Trách Nhiệm 4')
INSERT INTO SanPham VALUES
('Z37', N'Máy tính sách tay Z37', 'Z37', '2020-8-21', 222),
('2', N'Sản Phẩm 1', '2', '2020-8-21', 333),
('3', N'Sản Phẩm 2', '3', '2019-1-21', 444),
('4', N'Sản Phẩm 3', '4', '2009-8-30', 555),
('5', N'Sản Phẩm 4', '5', '2018-8-8', 666)

--4. Viết các câu lênh truy vấn để
	--a) Liệt kê danh sách loại sản phẩm của công ty.
SELECT TenSP FROM SanPham
	--b) Liệt kê danh sách sản phẩm của công ty.
SELECT IDSP, TenSP, NgayXS FROM SanPham
	--c) Liệt kê danh sách người chịu trách nhiệm của công ty.
SELECT TenNCTN FROM NguoiChiuTrachNhiem

--5. Viết các câu lệnh truy vấn để lấy
	--a) Liệt kê danh sách loại sản phẩm của công ty theo thứ tự tăng dần của tên
SELECT IDSP, TenSP FROM SanPham ORDER BY TenSP ASC
	--b) Liệt kê danh sách người chịu trách nhiệm của công ty theo thứ tự tăng dần của tên.
SELECT IDNCTN, TenNCTN FROM NguoiChiuTrachNhiem ORDER BY TenNCTN ASC
	--c) Liệt kê các sản phẩm của loại sản phẩm có mã số là Z37E.
SELECT TenSP FROM SanPham
WHERE IDSP = 'Z37'
	--d) Liệt kê các sản phẩm Nguyễn Văn An chịu trách nhiệm theo thứ tự giảm đần của mã.
SELECT TenSP, TenNCTN FROM SanPham 
INNER JOIN NguoiChiuTrachNhiem ON NguoiChiuTrachNhiem.IDNCTN = SanPham.IDNCTN
WHERE TenNCTN = N'Nguyễn Văn An'
ORDER BY TenNCTN DESC

--6. Viết các câu lệnh truy vấn để
	--a) Số sản phẩm của từng loại sản phẩm.
SELECT SUM(TenLoaiSP) AS N'Tổng Số Sản' FROM LoaiSanPham GROUP BY TenLoaiSP
	--c) Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm.
SELECT MaSP, TenSP, NgayXS FROM SanPham
WHERE MaSP IN (SELECT MaSP FROM LoaiSanPham)
	--d) Hiển thị toàn bộ thông tin về người chịu trách nhiêm, loại sản phẩm và sản phẩm.
SELECT TenNCTN, TenSP, TenLoaiSP, NgayXS FROM SanPham
INNER JOIN NguoiChiuTrachNhiem ON NguoiChiuTrachNhiem.IDNCTN = SanPham.IDNCTN
INNER JOIN LoaiSanPham ON LoaiSanPham.MaSP = SanPham.MaSP

--7. Thay đổi những thư sau từ cơ sở dữ liệu
	--a) Viết câu lệnh để thay đổi trường ngày sản xuất là trước hoặc bằng ngày hiện tại
ALTER TABLE SanPham ADD CONSTRAINT SP_NgayXS CHECK(NgayXS <= GetDate())
	----b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng.
ALTER TABLE SanPham ADD CONSTRAINT fk_LoaiSanPham FOREIGN KEY (MaSP) REFERENCES LoaiSanPham(MaSP)
ALTER TABLE SanPham ADD CONSTRAINT fk_NguoiChiuTrachNhiem FOREIGN KEY (IDNCTN) REFERENCES NguoiChiuTrachNhie(IDNCTN)
	--c) Viết câu lệnh để thêm trường phiên bản của sản phẩm.
ALTER TABLE SanPham ADD them1dong int

--8. Thực hiện các yêu cầu sau
	--a) Đặt chỉ mục (index) cho cột tên người chịu trách nhiệm
CREATE INDEX IX_NguoiChiuTrachNhiem ON NguoiChiuTrachNhiem(IDNCTN, TenNCTN)
	--b) Viết các View sau:
	--◦ View_SanPham: Hiển thị các thông tin Mã sản phẩm, Ngày sản xuất, Loại sản phẩm
CREATE VIEW View_SanPham AS
SELECT MaSP, TenSP, NgayXS FROM SanPham
	--◦ View_SanPham_NCTN: Hiển thị Mã sản phẩm, Ngày sản xuất, Người chịu trách nhiệm
CREATE VIEW View_SanPham_NCTN AS
SELECT MaSP, NgayXS, TenNCTN FROM SanPham
INNER JOIN NguoiChiuTrachNhiem ON SanPham.IDNCTN = NguoiChiuTrachNhiem.IDNCTN
	--◦ View_Top_SanPham: Hiển thị 5 sản phẩm mới nhất (mã sản phẩm, loại sản phẩm, ngày sản xuất)
CREATE VIEW View_Top_SanPham AS
SELECT TOP 5 MaSP, TenSP, NgayXS FROM SanPham ORDER BY NgayXS DESC
DROP VIEW View_Top_SanPham
	--c) Viết các Store Procedure sau:
	--◦ SP_Them_LoaiSP: Thêm mới một loại sản phẩm
CREATE PROCEDURE SP_Them_LoaiSP AS 
INSERT INTO LoaiSanPham VALUES ('7', N'Sản Phâm 7')
	--SP_Them_NCTN: Thêm mới người chịu trách nhiệm
CREATE PROCEDURE SP_Them_NCTN AS
INSERT INTO NguoiChiuTrachNhiem VALUES (777, N'Người Chịu Trách Nhiệm 7')
	--◦ SP_Them_SanPham: Thêm mới một sản phẩm
CREATE PROCEDURE SP_Them_SanPham AS
INSERT INTO SanPham VALUES ('A7', N'Sản Phẩm 7', '7', '2018-8-8', 777)
	--◦ SP_Xoa_SanPham: Xóa một sản phẩm theo mã sản phẩm
CREATE PROCEDURE SP_Xoa_SanPham AS
DELETE MaSP FROM SanPham
WHERE MaSP = 'A7'
	--◦ SP_Xoa_SanPham_TheoLoai: Xóa các sản phẩm của một loại nào đó
CREATE PROCEDURE SP_Xoa_SanPham_TheoLoai AS
DELETE TenSP FROM SanPham
WHERE TenSP = N'Sản Phẩm 7'