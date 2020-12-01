CREATE DATABASE QuanLySinhVien
Go
USE QuanLySinhVien
DROP DATABASE QuanLySinhVien
CREATE TABLE SinhVien(
	IDSinhVien varchar(10) PRIMARY KEY,
	HoTen nvarchar(50) NOT NULL,
	NgaySinh date,
	QueQuan varchar(50),
)
DROP TABLE SinhVien
CREATE TABLE Lop(
	IDLop varchar(10) PRIMARY KEY,
	TenLop varchar(50) NOT NULL,
)
DROP TABLE Lop
CREATE TABLE SinhVienLop(
	IDSinhVien varchar(10) NOT NULL,
	IDLop varchar(10) NOT NULL,
	HoTen varchar(50) NOT NULL,
	NamSinh date,
	QueQuan varchar(50) NOT NULL,
	MonHoc varchar(20) NOT NULL,
	CONSTRAINT fk FOREIGN KEY (IDSinhVien) REFERENCES SinhVien(IDSinhVien),
	CONSTRAINT ak FOREIGN KEY (IDLop) REFERENCES Lop(IDLop)
)
DROP TABLE SinhVienLop

INSERT INTO SinhVien VALUES 
('001', 'Chu Ba Thong', '1/1/1999', 'Toan Chan'),
('002', 'Quach Tinh', '2/1/1998', 'Cai Bang'),
('003', 'Dung Nhi', '3/1/1998', 'Cai Bang'),
('004', 'Qua Nhi', '4/2/1997', 'Co Mo'),
('005', 'Long Nhi', '5/2/1997', 'Co Mo')
SELECT * FROM SinhVien

INSERT INTO Lop VALUES 
('001', 'T2004M'),
('002', 'T2004M'),
('003', 'T2004M'),
('004', 'T2004M'),
('005', 'T2004M')
SELECT * FROM Lop

INSERT INTO SinhVienLop VALUES
('001', '001', 'Doan Chi Binh', '1/1/1999', 'Toan Chan', 'Nhat Duong Chi'),
('002', '002', 'Tieu Long Nu', '1/1/1998', 'Co Mo', 'Ngoc Nu Kiem Phap'),
('003', '003', 'Duong Qua', '2/2/1998', 'Co Mo', 'Am Nhien Tieu Hon'),
('004', '004', 'Quach Tinh', '3/8/8888', 'Cai Bang', 'Giang Long Thap Bat'),
('005', '005', 'Hoang Dung', '5/7/8888', 'Cai Bang', 'Da Cau Bong Phap')
SELECT * FROM SinhVienLop