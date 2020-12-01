CREATE DATABASE RiverPlate
GO
USE RiverPlate
GO
CREATE TABLE Student(
	StudentNO int PRIMARY KEY,
	StudentName varchar(50),
	StudentAddress varchar(100),
	PhoneID int,
)
CREATE TABLE Department (
	DeptNO int PRIMARY KEY,
	DeptName varchar(50),
	ManagerName char(30),
)
CREATE TABLE Assignment(
	AssignmentNO int PRIMARY KEY,
	Description varchar(100),
)
CREATE TABLE Works_Assgin(
	JobID int PRIMARY KEY,
	StudentNO int,
	AssignmentNO int,
	TotalHours int,
	JobDetails XML,
	CONSTRAINT fk_Student FOREIGN KEY (StudentNO) REFERENCES Student(StudentNO),
	CONSTRAINT FK_AssignmentNO FOREIGN KEY (AssignmentNO) REFERENCES Assignment(AssignmentNO)
)
--1. Người quản lý trường RiverPlate muốn hiển thị tên của sinh viên và mã số sinh viên của họ. Tạo
--một clustered index tên là IX_Student trên cột StudentNo của bảng Student, trong khi chỉ mục
--được tạo, các bảng và các chỉ mục có thể được sử dụng để truy vấn và thay đổi dữ liệu.
CREATE UNIQUE NONCLUSTERED INDEX IX_Student ON Student(StudentName)
--2.Chỉnh sửa và xây dựng lại (rebuild) IX_Student đã được tạo trên bảng Student trong đó các bảng
--và chỉ mục không thể sử dụng để truy vấn và thay đổi dữ liệu. 
ALTER INDEX IX_Student ON Student DISABLE
--3.Người quản lý trường đại học RiverPlate muốn lấy ra tên nhóm làm việc, người quản lý nhóm và
--mã số nhóm. Tạo một chỉ notclustered index tên là IX_Dept trên bảng Department sử dụng
--trường khóa DeptNo và 2 trường không khóa DeptName và DeptManagerNo. 
CREATE NONCLUSTERED INDEX IX_Dept ON Department(DeptName, ManagerName) WITH (ALLOW_ROW_LOCKS = ON)