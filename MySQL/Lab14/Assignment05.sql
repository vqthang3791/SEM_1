CREATE DATABASE Assignment05
GO
USE Assignment05
GO
--1. Thiết kế cơ sở dữ liệu cho việc lưu trữ danh bạ với các thông tin như sau
CREATE TABLE DanhBa (
	MaDB int PRIMARY KEY,
	TenDB nvarchar(50),
	DiaChi nvarchar(50),
	NgaySinh datetime,
)
CREATE TABLE DienThoai (
	MaDB int,
	SoDT int,
	CONSTRAINT fk_MaDB FOREIGN KEY (MaDB) REFERENCES DanhBa(MaDB),
)
--2. Viết các câu lệnh để tạo các bảng như thiết kế câu 1
--3. Viết các câu lệnh để thêm dữ liệu vào các bảng
	--Chèn thêm dữ liệu vào các bảng
INSERT INTO DanhBa VALUES 
(111, N'Khánh Trắng', N'Hà Nội', '1961-8-15'),
(222, N'Dung Hà', N'Hải Phòng', '1965-3-29'),
(333, N'Hải Bánh', N'Hà Nội', '1973-7-04'),
(444, N'Nam Cam', N'Sài Gòn', '1955-3-25'),
(555, N'Nguyễn Văn An', N'111 Nguyễn Trãi, Thanh Xuân, Hà Nội', '1987-8-11')
INSERT INTO DienThoai VALUES
(555, '987654321'),
(555, '09873452'),
(555, '09832323'),
(555, '09434343'),
(111, '987654321'),
(111, '987654321'),
(222, '987654321'),
(333, '987654321'),
(444, '987654321'),
(111, '987654321')
--4. Viết các câu lênh truy vấn để
	--a) Liệt kê danh sách những người trong danh bạ
SELECT TenDB, NgaySinh FROM DanhBa
	--b) Liệt kê danh sách số điện thoại có trong danh bạ
SELECT SoDT FROM DienThoai

--5. Viết các câu lệnh truy vấn để lấy
	--a) Liệt kê danh sách người trong danh bạ theo thứ thự alphabet.
SELECT TenDB FROM DanhBa ORDER BY TenDB
	--b) Liệt kê các số điện thoại của người có thên là Nguyễn Văn An.
SELECT TenDB, SoDT FROM DanhBa
INNER JOIN DienThoai ON DienThoai.MaDB = DanhBa.MaDB
WHERE TenDB = N'Nguyễn Văn An'
	--c) Liệt kê những người có ngày sinh là 12/12/09
SELECT TenDB FROM DanhBa
WHERE NgaySinh = '1961-8-15'

--6. Viết các câu lệnh truy vấn để
	--a) Tìm số lượng số điện thoại của mỗi người trong danh bạ.
SELECT TenDB,COUNT(SoDT) AS N'Số Điện Thoại Mỗi Người' FROM DienThoai
INNER JOIN DanhBa ON DanhBa.MaDB = DienThoai.MaDB 
GROUP BY TenDB
	--b) Tìm tổng số người trong danh bạ sinh vào thang 12.
SELECT TenDB, COUNT(MaDB) AS N'Tổng Người Sinh Tháng 3' FROM DanhBa
WHERE DATEPART(mm,NgaySinh) = '3' GROUP BY TenDB
	--c) Hiển thị toàn bộ thông tin về người, của từng số điện thoại.
SELECT TenDB, NgaySinh, DiaChi FROM DanhBa
	--d) Hiển thị toàn bộ thông tin về người, của số điện thoại 123456789.
SELECT TenDB, SoDT, DiaChi, NgaySinh FROM DanhBa
INNER JOIN DienThoai ON DanhBa.MaDB = DienThoai.MaDB
WHERE SoDT = '09832323'

--7. Thay đổi những thư sau từ cơ sở dữ liệu
	--a) Viết câu lệnh để thay đổi trường ngày sinh là trước ngày hiện tại.
ALTER TABLE DanhBa ADD CONSTRAINT fk_NgaySinh CHECK (NgaySinh < GETDATE())
	--b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng.
ALTER TABLE DanhBa ADD CONSTRAINT fk_MaDB PRIMARY KEY (MaDB)
ALTER TABLE DienThoai ADD CONSTRAINT fk_MaDB1 FOREIGN KEY (MaDB) REFERENCES DanhBa(MaDB)
	--c) Viết câu lệnh để thêm trường ngày bắt đầu liên lạc.
ALTER TABLE DanhBa ADD NgayBatDauLL DATETIME

--8. Thực hiện các yêu cầu sau
	--a) Thực hiện các chỉ mục sau(Index)
	--◦ IX_HoTen : đặt chỉ mục cho cột Họ và tên
CREATE INDEX IX_HoTen ON DanhBa(TenDB)
	--◦ IX_SoDienThoai: đặt chỉ mục cho cột Số điện thoại
CREATE INDEX IX_SoDienThoai ON DienThoai(SoDT)
	--b) Viết các View sau:
	--◦ View_SoDienThoai: hiển thị các thông tin gồm Họ tên, Số điện thoại
CREATE VIEW View_SoDienThoai AS
SELECT TenDB, SoDT FROM DanhBa
INNER JOIN DienThoai ON DienThoai.MaDB = DanhBa.MaDB
SELECT * FROM View_SoDienThoai
	--◦ View_SinhNhat: Hiển thị những người có sinh nhật trong tháng hiện tại (Họ tên, Ngày sinh, Số điện thoại)
CREATE VIEW View_SinhNhat AS
SELECT TenDB, SoDT, NgaySinh FROM DanhBa
INNER JOIN DienThoai ON Dienthoai.MaDB = DanhBa.MaDB
WHERE DATEPART(mm,NgaySinh) = DATEPART(mm,getdate())
	--c) Viết các Store Procedure sau:
	--◦ SP_Them_DanhBa: Thêm một người mới vào danh bạn
CREATE PROCEDURE SP_Them_DanhBa 
@MaDB int,
@TenDB nvarchar(50),
@DiaChi nvarchar(50),
@NgaySinh datetime,
@SoDT int,
AS
INSERT INTO DanhBa VALUES (@MaDB, @TenDB, @DiaChi, @NgaySinh)
INSERT INTO DienThoai VALUES (@MaDB, @SoDT)
	--◦ SP_Tim_DanhBa: Tìm thông tin liên hệ của một người theo tên (gần đúng)
CREATE PROCEDURE SP_Tim_DanhBa AS
SELECT DienThoai.MaDB, TenDB, DiaChi, NgaySinh, SoDT FROM DanhBa
INNER JOIN DienThoai ON DienThoai.MaDB = DanhBa.MaDB
WHERE TenDB LIKE '%'

SELECT * FROM DienThoai
SELECT * FROM DanhBa

DROP TABLE DienThoai
DROP TABLE DanhBa