CREATE DATABASE QuanLyNhanVien
GO
USE QuanLyNhanVien
GO
CREATE TABLE PhongBan(
	MaPB varchar(7) PRIMARY KEY,
	TenPB nvarchar(50),
)
CREATE TABLE NhanVien(
	MaNV varchar(7) PRIMARY KEY,
	TenNV nvarchar(50),
	NgaySinh datetime CHECK (NgaySinh < GETDATE()),
	SoCMND char(9),
	GioiTinh char(1) CHECK (GioiTinh IN ('F', 'M')),
	DiaChi nvarchar(100),
	NgayVaoLam datetime,
	MaPB varchar(7),
	CONSTRAINT fk_MaPB FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB)
)
ALTER TABLE NhanVien ADD CONSTRAINT Check_NgayVaoLam
	CHECK ((DATEPART(year, NgayVaoLam)) >= ((DATEPART(year, NgaySinh))+20))
CREATE TABLE LuongDA(
	MaDA varchar(8) PRIMARY KEY,
	MaNV varchar(7),
	NgayNhan Datetime DEFAULT GETDATE(),
	SoTien money CHECK (SoTien > 0),
	CONSTRAINT fk_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
)
--1. Thực hiện chèn dữ liệu vào các bảng vừa tạo (ít nhất 5 bản ghi cho mỗi bảng).
--Chèn Dữ liệu PhongBan
INSERT INTO PhongBan VALUES 
('001', 'Phong Ban 1'),
('006', 'Phong Ban 1'),
('002', 'Phong Ban 2'),
('003', 'Phong Ban 3'),
('004', 'Phong Ban 4'),
('005', 'Phong Ban 5')
--Chèn Dữ Liệu NhanVien
INSERT INTO NhanVien VALUES
('A12345', 'Duong Qua', '1991-1-1', '123457890', 'M', 'Co Mo', '2019-8-18', '001'),
('A11345', 'Qua Nhi', '1991-1-1', '123456799', 'F', 'Co Mo', '2019-8-18', '001'),
('A23456', 'Tieu Long Nu', '1992-1-1', '12356789', 'F', 'Co Mo', '2019-8-18', '002'),
('A34567', 'Quach Tinh', '1993-2-2', '124567892', 'M', 'Cai Bang', '2019-8-18', '003'),
('A45678', 'Hoang Dung', '1994-3-2', '134567893', 'F', 'Cai Bang', '2019-8-18', '004'),
('A56789', 'Doan Chi Binh', '1995-5-5', '234567894', 'F', 'Toan Chan', '2019-8-18', '005')
--Chèn Dữ Liệu vào LuongDA
INSERT INTO LuongDA VALUES
('ACB123XZ', 'A12345','2019-8-18', 15000),
('ACB124XZ', 'A11345','2019-8-18', 1400),
('ACB125XZ', 'A23456','2019-8-18', 130),
('ACB126XZ', 'A45678','2019-8-18', 120),
('ACB127XZ', 'A56789','2019-8-18', 110)
--2. Viết một query để hiển thị thông tin về các bảng LUONGDA, NHANVIEN, PHONGBAN.
SELECT * FROM PhongBan
SELECT * FROM NhanVien
SELECT * FROM LuongDA
--3. Viết một query để hiển thị những nhân viên có giới tính là ‘F’.
SELECT * FROM NhanVien WHERE GioiTinh LIKE '%F'
--4. Hiển thị tất cả các dự án, mỗi dự án trên 1 dòng.
SELECT DISTINCT MaDA FROM LuongDA GROUP BY MaDA
--5. Hiển thị tổng lương của từng nhân viên (dùng mệnh đề GROUP BY).
SELECT MaNV, SUM(SoTien) AS 'Tong Tien' FROM LuongDA GROUP BY MaNV
--6. Hiển thị tất cả các nhân viên trên một phòng ban cho trước (VD: ‘Hành chính’).
SELECT TenPB, MaNV, TenNV FROM PhongBan INNER JOIN NhanVien ON PhongBan.MaPB = NhanVien.MaPB WHERE PhongBan.MaPB = 001
--7. Hiển thị mức lương của những nhân viên phòng hành chính.
SELECT TenNV, SoTien FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV WHERE NhanVien.MaPB = 001
--8. Hiển thị số lượng nhân viên của từng phòng.
SELECT COUNT(DISTINCT MaNV) AS TongNhanVien FROM NhanVien WHERE NhanVien.MaPB = 001
SELECT COUNT(DISTINCT MaNV) AS TongNhanVien FROM NhanVien WHERE NhanVien.MaPB = 002
SELECT COUNT(DISTINCT MaNV) AS TongNhanVien FROM NhanVien WHERE NhanVien.MaPB = 003
SELECT COUNT(DISTINCT MaNV) AS TongNhanVien FROM NhanVien WHERE NhanVien.MaPB = 004
SELECT COUNT(DISTINCT MaNV) AS TongNhanVien FROM NhanVien WHERE NhanVien.MaPB = 005
--9. Viết một query để hiển thị những nhân viên mà tham gia ít nhất vào một dự án.
SELECT TenNV, MaDA FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
--10. Viết một query hiển thị phòng ban có số lượng nhân viên nhiều nhất.
SELECT TOP 1 PhongBan.MaPB, PhongBan.TenPB, COUNT(PhongBan.MaPB) AS SoLuong FROM PhongBan INNER JOIN NhanVien ON PhongBan.MaPB = NhanVien.MaPB
GROUP BY PhongBan.MaPB, NhanVien.MaPB, PhongBan.TenPB ORDER BY SoLuong DESC
--11. Tính tổng số lượng của các nhân viên trong phòng Hành chính.(2)
SELECT COUNT(DISTINCT MaNV) AS PhongHanhChinh FROM NhanVien WHERE NhanVien.MaPB = '002'
--12. Hiển thị tống lương của các nhân viên có số CMND tận cùng bằng 9.
SELECT right(SoCMND, 1), SUM(SoTien), SoCMND, SoTien FROM NhanVien  
INNER JOIN LuongDA ON NhanVien.MaNV  = LuongDA.MaNV
WHERE right(SoCMND, 1) = '9'
GROUP BY SoCMND, SoTien
--13. Tìm nhân viên có số lương cao nhất.
SELECT Top 1 (SoTien), (TenNV)  AS 'Nhieu Tien Nhat' FROM LuongDA INNER JOIN NhanVien ON NhanVien.MaNV = LuongDA.MaNV
--14. Tìm nhân viên ở phòng Hành chính có giới tính bằng ‘F’ và có mức lương > 1200000.
SELECT TenNV 
FROM NhanVien INNER JOIN PhongBan ON PhongBan.MaPB = NhanVien.MaPB
			  INNER JOIN LuongDA On LuongDA.MaNV= NhanVien.MaNV
WHERE TenPB = '001' AND  GioiTinh = 'F' AND SoTien > 12000
--15. Tìm tổng lương trên từng phòng.
SELECT SUM(SoTien) FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
								 JOIN PhongBan ON PhongBan.MaPB = NhanVien.MaPB
WHERE TenPB =  '001'
SELECT SUM(SoTien) FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
								 INNER JOIN PhongBan ON PhongBan.MaPB = NhanVien.MaPB
WHERE TenPB =  '002'
SELECT SUM(SoTien) FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
								 INNER JOIN PhongBan ON PhongBan.MaPB = NhanVien.MaPB
WHERE TenPB =  N'003'
SELECT SUM(SoTien) FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
								 INNER JOIN PhongBan ON PhongBan.MaPB = NhanVien.MaPB
WHERE TenPB =  N'004'
SELECT SUM(SoTien) FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
								 INNER JOIN PhongBan ON PhongBan.MaPB = NhanVien.MaPB
WHERE TenPB =  N'005'
--16. Liệt kê các dự án có ít nhất 2 người tham gia.
SELECT MaDA FROM LuongDA GROUP BY MaDA HAVING COUNT(MaNV) >=2
--17. Liệt kê thông tin chi tiết của nhân viên có tên bắt đầu bằng ký tự ‘N’.
SELECT * FROM NhanVien WHERE TenNV LIKE '[N]%'
--18. Hiển thị thông tin chi tiết của nhân viên được nhận tiền dự án trong năm 2019.
SELECT * FROM LuongDA  WHERE NgayNhan= '2019-8-18'
--19. Hiển thị thông tin chi tiết của nhân viên không tham gia bất cứ dự án nào.
SELECT * FROM LuongDA WHERE MaDA=''
--20. Xoá dự án có mã dự án là ACB123XZ.
DELETE FROM luongDA WHERE MaDA='ACB123XZ'
--21. Xoá đi từ bảng LuongDA những nhân viên có mức lương 2000000.
DELETE FROM LuongDA WHERE SoTien='120'
--22. Cập nhật lại lương cho những người tham gia dự án ACB123XZ thêm 10% lương cũ.
UPDATE LuongDA SET SoTien = '90000'
WHERE MaDA = 'ACB123XZ';
SELECT * FROM LuongDA;
--23. Xoá các bản ghi tương ứng từ bảng NhanVien đối với những nhân viên không có mã nhân viên tồn tại trong bảng LuongDA.
DELETE FROM NhanVien WHERE MaNV not in (SELECT MaNV FROM LuongDA)
--24. Viết một truy vấn đặt lại ngày vào làm của tất cả các nhân viên thuộc phòng hành chính là ngày 12/02/1999
UPDATE 002
SET NgayVaoLam = 2017-8-18
SELECT * FROM 002


DROP TABLE PhongBan
DROP TABLE NhanVien
DROP TABLE LuongDA

SELECT * FROM PhongBan
SELECT * FROM NhanVien
SELECT * FROM LuongDA