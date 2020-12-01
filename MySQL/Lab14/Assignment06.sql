CREATE DATABASE Assignment06
GO
USE Assignment06
GO
DROP DATABASE Assignment06
CREATE TABLE NXB (
	MaNXB int PRIMARY KEY,
	TenNXB nvarchar(50),
	DiaChi nvarchar(50),
)
CREATE TABLE TheLoaiSach (
	MaTheLoai int PRIMARY KEY,
	TheLoai nvarchar(50),
)
CREATE TABLE TacGia (
	TenTG nvarchar(50) PRIMARY KEY,
	DiaChiTG nvarchar(50),
)
CREATE TABLE Sach (
	MaSach nvarchar(10) PRIMARY KEY,
	TenSach nvarchar(200),
	TenTG nvarchar(50),
	NoiDung nvarchar(500),
	MaNXB int,
	MaTheLoai int,
	NgayXB DATETIME,
	SoLanXB int,
	SoLuongIn int,
	GiaTien money,
	CONSTRAINT fk_TenTG FOREIGN KEY (TenTG) REFERENCES TacGia(TenTG),
	CONSTRAINT fk_MaNXS FOREIGN KEY (MaNXB) REFERENCES NXB(MaNXB),
	CONSTRAINT fk_MaTheLoai FOREIGN KEY (MaTheLoai) REFERENCES TheLoaiSach(MaTheLoai)
)
--2. Viết lệnh SQL chèn vào các bảng của CSDL các dữ liệu mẫu
INSERT INTO NXB VALUES
('1001', N'NXB Tri Thức', N'53 Nguyễn Du, Hai Bà Trưng, Hà Nội'),
('1002', N'NXB Kim Đồng', N'55 Nguyễn Du, Hai Bà Trưng, Hà Nội'),
('1003', N'NXB Trẻ', N'161B Lý Chính Thắng, Phường 7, Quận 3, Hồ Chí Minh'),
('1004', N'NXB Chính Trị Quốc Gia Sự Thật', N'Số 6/86 Duy Tân, Cầu Giấy, Hà Nội'),
('1005', N'NXB Giáo Dục', N'81 Trần Hưng Đạo, Hà Nội')
INSERT INTO TheLoaiSach VALUES
(111, N'Khoa Học - Xã Hội'),
(222, N'Văn Học - Việt Nam'),
(333, N'Nghệ Thuật - Giải Trí'),
(444, N'Quốc Phòng - An Ninh - Đối Ngoại'),
(555, N'Kết Nối Tri Thức - Cuộc Sống')
INSERT INTO TacGia VALUES 
(N'Eran Katz', N'Địa Chỉ Nhà Tác Giả Eran Katz'),
(N'Châu Tấn', N'Địa Chỉ Nhà Tác Giả Châu Tấn'),
(N'Keith Abraham', N'Địa Chỉ Nhà Tác Giả Keith Abraham'),
(N'Bộ Ngoại Giao', N'Số 1 Tôn Thất Đàm, Ba Đình, Hà Nội'),
(N'Latifa Gallo', N'Địa Chỉ Nhà Tác Giả Latifa Gallo')
INSERT INTO Sach VALUES
('B001',N'Trí tuệ Do Thái', N'Eran Katz', N'Nội Dung 1', '1001', 111, '2005-5-15', 1, 100, 79000),
('A002B',N'VÕ QUẢNG - MỘT ĐỜI THƠ VĂN', N'Châu Tấn', N'Nội Dung 2', '1002', 222, '2020-07-20', 6, 50, 180000),
('A003C',N'Bắt Đầu Từ Đam Mê', N'Keith Abraham', N'Nội Dung 3', '1003', 333, '2005-2-28', 5, 200, 11500),
('A004D',N'Ngoại giao Việt Nam 2001-2015', N'Bộ Ngoại Giao', N'Nội Dung 4', '1004', 444, '2005-11-30', 3, 500, 75000),
('F008D',N'Suy Nghĩ Tích Cực', N'Latifa Gallo', N'Nội Dung 5', '1005', 555, '2005-8-28', 1, 100, 38000)

--3. Liệt kê các cuốn sách có năm xuất bản từ 2008 đến nay
SELECT TenSach, GiaTien FROM Sach
WHERE YEAR(NgayXB) >= 2008

--4. Liệt kê 10 cuốn sách có giá bán cao nhất
SELECT TOP 10 TenSach, GiaTien FROM Sach ORDER BY GiaTien DESC

--5. Tìm những cuốn sách có tiêu đề chứa từ “tin học”
SELECT TenSach FROM Sach
WHERE TenSach LIKE N'%Tích Cực%'

--6. Liệt kê các cuốn sách có tên bắt đầu với chữ “T” theo thứ tự giá giảm dần
SELECT TenSach FROM Sach
WHERE TenSach LIKE 'T%'

--7. Liệt kê các cuốn sách của nhà xuất bản Tri thức
SELECT TenSach, TenNXB, Sach.MaNXB FROM Sach
INNER JOIN NXB ON Sach.MaNXB = NXB.MaNXB
WHERE TenNXB = N'NXB Tri thức'

--8. Lấy thông tin chi tiết về nhà xuất bản xuất bản cuốn sách “Trí tuệ Do Thái”
SELECT TenSach, TenNXB, Sach.TenTG, NgayXB, SoLanXB, SoLuongIN FROM Sach
INNER JOIN TacGia ON TacGia.TenTG = Sach.TenTG
INNER JOIN NXB ON NXB.MaNXB = Sach.MaNXB
WHERE TenSach = N'Trí Tuệ Do Thái'

--9. Hiển thị các thông tin sau về các cuốn sách: Mã sách, Tên sách, Năm xuất bản, Nhà xuất bản, Loại sách
SELECT MaSach, TenSach, NgayXB, TenNXB, TheLoai FROM Sach
INNER JOIN TacGia ON TacGia.TenTG = Sach.TenTG
INNER JOIN NXB ON NXB.MaNXB = Sach.MaNXB
INNER JOIN TheLoaiSach ON TheLoaiSach.MaTheLoai = Sach.MaTheLoai

--10. Tìm cuốn sách có giá bán đắt nhất
SELECT TOP 1 * FROM Sach ORDER BY GiaTien DESC

--11. Tìm cuốn sách có số lượng lớn nhất trong kho
SELECT TOP 1 * FROM Sach ORDER BY SoLuongIn DESC

--12. Tìm các cuốn sách của tác giả “Eran Katz”
SELECT TenSach, TenTG FROM Sach 
WHERE TenTG = 'Eran Katz'

--13. Giảm giá bán 10% các cuốn sách xuất bản từ năm 2008 trở về trước
UPDATE Sach 
SET GiaTien = GiaTien/10
WHERE YEAR(NgayXB) < 2008

--14. Thống kê số đầu sách của mỗi nhà xuất bản
SELECT TenNXB, COUNT(MaSach) AS N'Tổng Số Đầu Sách Mỗi Nhà Xuất Bản' FROM Sach
INNER JOIN NXB ON NXB.MaNXB = Sach.MaNXB GROUP BY TenNXB

--15. Thống kê số đầu sách của mỗi loại sách
SELECT TheLoai, COUNT(TheLoai) AS N'Thống Ke Sổ : Đầu Sách Mỗi Loại' FROM Sach
INNER JOIN TheLoaiSach ON TheLoaiSach.MaTheLoai = Sach.MaTheLoai GROUP BY TheLoai

--16. Đặt chỉ mục (Index) cho trường tên sách
CREATE INDEX IX_Sach ON Sach(TenSach)

--17. Viết view lấy thông tin gồm: Mã sách, tên sách, tác giả, nhà xb và giá bán
CREATE VIEW View_MaSach_TenSach_TacGia_TenNXB_GiaTien AS 
SELECT MaSach, TenSach, TenTG, TenNXB, GiaTien FROM Sach
INNER JOIN NXB ON NXB.MaNXB = Sach.MaNXB
INNER JOIN TheLoaiSach ON TheLoaiSach.MaTheLoai = Sach.MaTheLoai

--18. Viết Store Procedure:
	--◦ SP_Them_Sach: thêm mới một cuốn sách
CREATE PROCEDURE SP_Them_Sach 
@MaSach nvarchar(10),
@TenSach nvarchar(200),
@TenTG nvarchar(50),
@NoiDung nvarchar(500),
@MaNXB int,
@MaTheLoai int,
@NgayXB DATETIME,
@SoLanXB int,
@SoLuongIn int,
@GiaTien money
AS
INSERT INTO Sach(@MaSach, @TenSach, @TenTG, @NoiDung, @MaNXB, @MaTheLoai, @NgayXB, @SoLanXB, @SoLuongIn, @GiaTien) VALUES 
(@MaSach, @TenSach, @TenTG, @NoiDung, @MaNXB, @MaTheLoai, @NgayXB, @SoLanXB, @SoLuongIn, @GiaTien)

	--◦ SP_Tim_Sach: Tìm các cuốn sách theo từ khóa
CREATE PROCEDURE SP_Tim_Sach @TuKhoa AS
SELECT * FROM Sach
WHERE TenSach LIKE '%' + @TuKhoa + '%' --(NoiDung LIKE '%' + @TuKhoa + '%')
DROP PROCEDURE SP_Tim_Sach
	--◦ SP_Sach_ChuyenMuc: Liệt kê các cuốn sách theo mã chuyên mục
CREATE PROCEDURE SP_Sach_ChuyenMuc @MaTheLoai AS
SELECT * FROM Sach 
WHERE MaTheLoai = @MaTheLoai

--19. Viết trigger không cho phép xóa các cuốn sách vẫn còn trong kho (số lượng > 0)
CREATE TRIGGER TG_Khongchophepxoa ON Sach 
FOR DELETE AS
IF EXISTS (Select SoLuongIn FROM DELETED WHERE SoLuongIn > 0)
BEGIN
	PRINT N'Sách Vẫn Còn ! '
	ROLLBACK
END

--20. Viết trigger chỉ cho phép xóa một danh mục sách khi không còn cuốn sách nào thuộc chuyên mục này.
CREATE TRIGGER TG_Chichophepxoa1danhmuc ON TheLoaiSach
FOR DELETE AS
IF EXISTS (SELECT * FROM TheLoaiSach WHERE MaTheLoai IN(SELECT MaTheLoai FROM DELETED))
BEGIN
	PRINT N'Sách Còn ! Không được Xóa'
	ROLLBACK TRAN
END