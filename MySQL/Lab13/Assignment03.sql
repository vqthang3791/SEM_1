CREATE DATABASE Assignment03
GO
USE Assignment03
GO

--1. Thiết kế cơ sở dữ liệu cho việc lưu trữ thông tin đăng ký điện thoại như sau
CREATE TABLE KhachHang (
	IDKH int PRIMARY KEY,
	TenKH nvarchar(50),
	DiaChi nvarchar(50),
	NgayDK datetime,
	GioiTinh Char CHECK (GioiTinh IN ('M', 'F')),
	CMND char(9),
)
CREATE TABLE LoaiThueBao (
	IDTB int PRIMARY KEY,
	LoaiTB nvarchar(20),
)
CREATE TABLE ThueBao (
	SoTB int PRIMARY KEY,
	IDKH int,
	IDTB int,
	TenTB varchar(20),
	NgayDKHT datetime,
	CONSTRAINT fk_IDKH FOREIGN KEY (IDKH) REFERENCES KhachHang(IDKH),
	CONSTRAINT fk_IDTB FOREIGN KEY (IDTB) REFERENCES  LoaiThueBao(IDTB)
)

--2. Viết các câu lệnh để tạo các bảng như thiết kế câu 1

--3. Viết các câu lệnh để thêm dữ liệu vào các bảng
	--Chèn thêm dữ liệu tương tự như đề bài
INSERT INTO KhachHang VALUES
(111, N'Khánh Trắng', N'Hà Nội', '2002-12-12', 'M', '123456789'),
(112, N'Dung Hà', N'Hải Phòng', '1999-11-21', 'F', '234567890'),
(113, N'Nam Cam', N'Sài Gòn', '2002-12-12', 'M', '345678901'),
(114, N'Phước 8 Ngón', N'Đồng Tháp', '2009-11-21', 'M', '456789123'),
(115, N'Hải Bánh', N'Hà Nội', '2020-4-24', 'F', '678945632')
SELECT * FROM KhachHang
INSERT INTO LoaiThueBao VALUES
(666, N'Trả Trước'),
(222, N'Trả Sau'),
(333, N'Trả Trước'),
(444, N'Trả Sau'),
(555, N'Trả Trước')
INSERT INTO ThueBao VALUES
(123456789, 111, 666, 'VIETTEL', '2002-12-13'),
(18008192, 112, 222, 'VIETTEL', '2002-12-13'),
(18008198, 113, 333, 'VIETTEL', '2002-12-13'),
(18002122, 114, 444, 'VIETTEL', '2002-12-13'),
(18003133, 115, 555, 'VIETTEL', '2002-12-13')

--4. Viết các câu lênh truy vấn để
	--a) Hiển thị toàn bộ thông tin của các khách hàng của công ty.
SELECT * FROM KhachHang
	--b) Hiển thị toàn bộ thông tin của các số thuê bao của công ty.
SELECT * FROM ThueBao
--5. Viết các câu lệnh truy vấn để lấy
	--a) Hiển thị toàn bộ thông tin của thuê bao có số: 0123456789
SELECT * FROM ThueBao 
WHERE SoTB = '123456789'
	--b) Hiển thị thông tin về khách hàng có số CMTND: 123456789
SELECT * FROM KhachHang
WHERE CMND = '123456789'
	--c) Hiển thị các số thuê bao của khách hàng có số CMTND:123456789
SELECT TenKH, DiaChi, NgayDK, NgayDKHT, TenTB FROM KhachHang
INNER JOIN ThueBao ON KhachHang.IDKH = ThueBao.IDKH
WHERE CMND = '123456789'
	--d) Liệt kê các thuê bao đăng ký vào ngày 2002-12-13
SELECT SoTB, NgayDKHT FROM ThueBao
WHERE NgayDKHT = '2002-12-13'
	--e) Liệt kê các thuê bao có địa chỉ tại Hà Nội
SELECT SoTB, TenKH, DiaChi FROM KhachHang
INNER JOIN ThueBao ON ThueBao.IDKH = KhachHang.IDKH
WHERE DiaChi = N'Hà Nội'

--6. Viết các câu lệnh truy vấn để lấy
	--a) Tổng số khách hàng của công ty.
SELECT COUNT(IDKH) AS N'Tổng Số Khách Hàng' FROM KhachHang
	--b) Tổng số thuê bao của công ty.
SELECT COUNT(IDTB) AS N'Tổng Số Thuê Bao' FROM ThueBao
	--c) Tổng số thuê bào đăng ký ngày 12/12/09.
SELECT COUNT(IDTB) AS N'Tổng Số Thuê Bao Đăng Ký Ngày 2002-12-13' FROM ThueBao
WHERE NgayDKHT = '2002-12-13'
	--d) Hiển thị toàn bộ thông tin về khách hàng và thuê bao của tất cả các số thuê bao.
SELECT TenKH, DiaChi, NgayDK, GioiTinh, CMND, SoTB, TenTB, NgayDKHT, LoaiTB FROM KhachHang
INNER JOIN ThueBao ON ThueBao.IDKH = KhachHang.IDKH
INNER JOIN LoaiThueBao ON ThueBao.IDTB = LoaiThueBao.IDTB




SELECT * FROM KhachHang
SELECT * FROM ThueBao
SELECT * FROM LoaiThueBao