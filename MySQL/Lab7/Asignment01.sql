CREATE DATABASE Assignment01
GO
USE Assignment01
GO
--1. Thiết kế cơ sở dữ liệu cho việc lưu trữ đơn hàng của công ty với các thông tin như sau:
--2. Viết các câu lệnh để tạo các bảng như thiết kế câu 1
--3. Viết các câu lệnh để thêm dữ liệu vào các bảng : Cho vào hai dữ liệu tưng tự như bảng đề bài trên
CREATE TABLE NguoiMua(
	MaKH varchar(10) PRIMARY KEY,
	NguoiDatHang nvarchar(50),
	DiaChi nvarchar(50),
	DienThoai char(9),
	CONSTRAINT fk_DienThoai CHECK (DienThoai NOT LIKE '%[^0-9]%')
)
CREATE TABLE SanPham(
	MaSP varchar(10) PRIMARY KEY,
	TenSP nvarchar(30),
	MoTa nvarchar(50),
	GiaBan money CHECK (GiaBan > 0)
)
CREATE TABLE DonDatHang(
	MaDatHang int PRIMARY KEY,
	MaKH varchar(10),
	NgayDatHang datetime,
	SoLuong int CHECK (SoLuong > 0),
	TongTien money,
	CONSTRAINT fk_NguoiMua FOREIGN KEY (MaKH) REFERENCES NguoiMua(MaKH)
)
CREATE TABLE DonHangChiTiet(
	MaKH varchar(10),
	MaDonHang int PRIMARY KEY,
	MaSP varchar(10),
	GiaBan money CHECK (GiaBan > 0),
	SoLuong int,
	CONSTRAINT fk_SanPham FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
	CONSTRAINT fk_KhachHang FOREIGN KEY (MaKH) REFERENCES NguoiMua(MaKH)
)
INSERT INTO NguoiMua VALUES 
(123, N'Nguyễn Văn An', N'111 Nguyễn Trãi, Thanh Xuân, Hà Nội', '987654321'),
(124, N'Nguyễn Văn An', N'123 Nguyễn Trãi, Thanh Xuân, Hà Nội', '123456789')
INSERT INTO SanPham VALUES
('T1', N'Máy Tính T450', N'Máy Mới Nhập', 1000),
('T2', N'Điện Thoại Nokia5670', N'Điện Thoại Đang Hot', 200),
('T3', N'Máy In Samsung', N'Máy In Đang Ế', 100)
INSERT INTO DonDatHang VALUES 
(111, 123, '2011-11-11', 2, 1500),
(222, 124, '2011-11-11', 1, 1300)
INSERT INTO DonHangChiTiet VALUES 
(123, 11, 'T1', 1000, 1),
(123, 12, 'T2', 200, 2),
(123, 13, 'T3', 100, 1)
--4. Viết các câu lênh truy vấn để
--a) Liệt kê danh sách khách hàng đã mua hàng ở cửa hàng.
SELECT MaKH, NguoiDatHang FROM NguoiMua
--b) Liệt kê danh sách sản phẩm của của hàng
SELECT MaSP, TenSP, MoTa, GiaBan FROM SanPham
--c) Liệt kê danh sách các đơn đặt hàng của cửa hàng.
SELECT MaDonHang, MaSP, GiaBan, SoLuong  FROM DonHangChiTiet
--5. Viết các câu lệnh truy vấn để
--a) Liệt kê danh sách khách hàng theo thứ thự alphabet
SELECT MaKH, NguoiDatHang FROM NguoiMua ORDER BY NguoiDatHang
--b) Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần
SELECT MaSP, TenSP, MoTa, GiaBan FROM SanPham ORDER BY GiaBan DESC
--c) Liệt kê các sản phẩm mà khách hàng Nguyễn Văn An đã mua
SELECT NguoiDatHang, TenSP, MoTa, SoLuong, DonHangChiTiet.GiaBan FROM DonHangChiTiet
INNER JOIN NguoiMua ON NguoiMua.MaKH = DonHangChiTiet.MaKH
INNER JOIN SanPham ON SanPham.MaSP = DonHangChiTiet.MaSP
WHERE NguoiDatHang = N'Nguyễn Văn An'
--6. Viết các câu lệnh truy vấn để
--a) Số khách hàng đã mua ở cửa hàng.
SELECT NguoiDatHang, COUNT(*) AS SoKhachHang FROM NguoiMua GROUP BY NguoiDatHang
--b) Số mặt hàng mà cửa hàng bán
SELECT TenSP, MaDonHang, SoLuong AS N'Số Lượng Đã Bán' FROM SanPham 
INNER JOIN DonHangChiTiet ON DonHangChiTiet.MaSP = SanPham.MaSP
--c) Tổng tiền của từng đơn hàng
SELECT NguoiDatHang, SUM(GiaBan) AS N'Tổng Tiền' FROM DonHangChiTiet, NguoiMua GROUP BY NguoiDatHang
--7. Thay đổi những thông tin sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0).
ALTER TABLE SanPham ADD CONSTRAINT SP CHECK(GiaBan > 0)
--b) Viết câu lệnh để thay đổi ngày đặt hàng của khách hàng phải nhỏ hơn ngày hiện tại.
ALTER TABLE DonDatHang ADD CONSTRAINT ThayDoi CHECK (NgayDatHang < GETDATE())
--c) Viết câu lệnh để thêm trường ngày xuất hiện trên thị trường của sản phẩm
ALTER TABLE SanPham ADD NgayXuatHien DATETIME CHECK (NgayXuatHien < GETDATE())
--8. Thực hiện các yêu cầu sau
--a) Đặt chỉ mục (index) cho cột Tên hàng và Người đặt hàng để tăng tốc độ truy vấn dữ liệu trên các cột này
CREATE INDEX SanPham_NguoiDatHang ON SanPham(TenSP, GiaBan, MoTa)
CREATE INDEX Nguoi_Dat_Hang ON NguoiMua(MaKH, NguoiDatHang, DiaChi, DienThoai)
--b) Xây dựng các view sau đây:
--View_KhachHang với các cột: Tên khách hàng, Địa chỉ, Điện thoại
CREATE VIEW KhachHang AS
SELECT MaKH, NgayDatHang FROM DonDatHang(
SELECT NguoiDatHang, DiaChi, DienThoai FROM DonHangChiTiet
INNER JOIN NguoiMua ON NguoiMua.MaKH = DonHangChiTiet.MaKH
INNER JOIN SanPham ON SanPham.MaSP = DonHangChiTiet.MaSP)

--View_SanPham với các cột: Tên sản phẩm, Giá bán
CREATE VIEW SanPham1 AS
SELECT MaKH, NgayDatHang FROM DonDatHang(
SELECT TenSP, GiaBan FROM DonHangChiTiet
INNER JOIN NguoiMua ON NguoiMua.MaKH = DonHangChiTiet.MaKH
INNER JOIN SanPham ON SanPham.MaSP = DonHangChiTiet.MaSP)

--View_KhachHang_SanPham với các cột: Tên khách hàng, Số điện thoại, Tên sản
CREATE VIEW KhachHang_SanPham AS 
SELECT MaKH, NgayDatHang FROM DonDatHang(
SELECT NguoiDatHang, DienThoai, TenSP FROM DonHangChiTiet
INNER JOIN NguoiMua ON NguoiMua.MaKH = DonHangChiTiet.MaKH
INNER JOIN SanPham ON SanPham.MaSP = DonHangChiTiet.MaSP)

----c) Viết các Store Procedure (Thủ tục lưu trữ) sau:
--◦ SP_TimKH_MaKH: Tìm khách hàng theo mã khách hàng
CREATE PROCEDURE TimKH_MaKH AS
BEGIN
SELECT NguoiDatHang FROM NguoiMua ORDER BY MaKH
END
EXEC TimKH_MaKH

--◦ SP_TimKH_MaHD: Tìm thông tin khách hàng theo mã hóa đơn
CREATE PROCEDURE TimKH_MaHD AS
BEGIN
SELECT NguoiDatHang, DiaChi, DienThoai FROM DonDatHang AS DDT
INNER JOIN NguoiMua AS NM ON DDT.MaKH = NM.MaKH ORDER BY MaDatHang
END
EXEC TimKH_MaHD

----◦ SP_SanPham_MaKH: Liệt kê các sản phẩm được mua bởi khách hàng có mã được truyền vào Store.
CREATE PROCEDURE SanPham_MaKH AS
BEGIN
SELECT TenSP, MoTa, GiaBan FROM SanPham AS SP
INNER JOIN DonHangChiTiet AS DHCT ON DHCT.MaSP = SP.MaSP ORDER BY MaDatHang
END
EXEC SP_SanPham_MaKH



DROP VIEW KhachHang_SanPham

SELECT * FROM NguoiMua
SELECT * FROM SanPham
SELECT * FROM DonDatHang
SELECT * FROM DonHangChiTiet
SELECT * FROM NguoiMua, SanPham, DonDatHang, DonHangChiTiet

DROP TABLE NguoiMua
DROP TABLE SanPham
DROP TABLE DonDatHang
DROP TABLE DongHangChiTiet
