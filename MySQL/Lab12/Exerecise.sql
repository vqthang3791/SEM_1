CREATE DATABASE CitySoftware
GO
USE CitySoftware
GO
CREATE TABLE Employee (
	EmployeeID int PRIMARY KEY,
	Name varchar(100),
	Tel char(11),
	Email varchar(30),
)
CREATE TABLE Project (
	ProjectID int PRIMARY KEY,
	ProjectName varchar(30),
	StartDate datetime,
	EndDate datetime,
	Period int,
	Cost money,
)
CREATE TABLE Group1 (
	GroupID int PRIMARY KEY,
	GroupName varchar(30),
	LeaderID int,
	ProjectID int,
	CONSTRAINT fk_projectid FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
)
Create TABLE GroupDetail (
	GroupID int,
	EmloyeeID int, 
	Status char(20),
	CONSTRAINT fk_grID FOREIGN KEY (GroupID) REFERENCES Group1(GroupID),
	CONSTRAINT fk_emloyID FOREIGN KEY (EmloyeeID) REFERENCES Employee(EmployeeID),
)
--1. Xác định thuộc tính khóa (khóa chính, khóa ngoại) và viết câu lệnh thay đổi các trường với thuộc
--tính khóa vừa xác định.

--2. Thêm dữ liệu cho các bảng
INSERT INTO Employee VALUES  -- EmployeeID(Employee, GroupDetail)
(111, 'Babu', '123456789', 'babu@gmail.com'),
(222, 'Lucas', '987654321', 'lucas@gmail.com'),
(333, 'Ronado', '852369741', 'ronado@gmail.com'),
(444, 'Messi', '654123987', 'messi@gmail.com'),
(555, 'Rocasto', '325874123', 'rocasto@gmail.com')
INSERT INTO Project VALUES --(ProjectID Group1)
(999, 'Xe O To', '2011-1-1', '2016-1-1', 5, 2500),
(888, 'Xe May', '2012-1-1', '2020-1-1', 8, 3500),
(777, 'Xay Nha', '2009-1-1', '2030-1-1', 21, 4000),
(666, 'Tinh Thuong', '2011-1-1', '2012-1-1', 1, 500),
(123, 'Chinh Phu', '2011-1-1', '2022-1-1', 11, 1000)
INSERT INTO Group1 VALUES  --(GroupID, GroupDetail)
(112, 'Nhom1', '11111', '999'),
(113, 'Nhom2', '11112', '888'),
(114, 'Nhom3', '11113', '777'),
(115, 'Nhom4', '11114', '666'),
(116, 'Nhom5', '11115', '123')
INSERT INTO GroupDetail VALUES --GroupID, EmloyeeID
(112, 111, 'Da Xong'),
(113, 222, 'Dang Lam'),
(114, 333, 'Chua Lam'),
(115, 444, 'Da Xong'),
(116, 555, 'Dang Lam')

--3. Viết câu lệnh truy vấn để:
--a. Hiển thị thông tin của tất cả nhân viên
SELECT Name, Tel, Email FROM Employee

--b. Liệt kê danh sách nhân viên đang làm dự án “Chính phủ điện tử”
SELECT ProjectID, ProjectName FROM Project
WHERE ProjectName = 'Chinh Phu'

--c. Thống kê số lượng nhân viên đang làm việc tại mỗi nhóm
SELECT COUNT(DISTINCT GroupID) AS N'Tổng Số Nhân Viên Nhóm 1' FROM Group1
WHERE GroupID = 112
SELECT COUNT(DISTINCT GroupID) AS N'Tổng Số Nhân Viên Nhóm 2' FROM Group1
WHERE GroupID = 113
SELECT COUNT(DISTINCT GroupID) AS N'Tổng Số Nhân Viên Nhóm 3' FROM Group1
WHERE GroupID = 114
SELECT COUNT(DISTINCT GroupID) AS N'Tổng Số Nhân Viên Nhóm 4' FROM Group1
WHERE GroupID = 115
SELECT COUNT(DISTINCT GroupID) AS N'Tổng Số Nhân Viên Nhóm 5' FROM Group1
WHERE GroupID = 116

--d. Liệt kê thông tin cá nhân của các trưởng nhóm
SELECT LeaderID, Name, Tel, Email From Employee
	INNER JOIN GroupDetail ON GroupDetail.EmloyeeID = Employee.EmployeeID
	INNER JOIN Group1 ON Group1.GroupID = GroupDetail.GroupID

--e. Liệt kê thông tin về nhóm và nhân viên đang làm các dự án có ngày bắt đầu làm trước ngày
--12/10/2010
SELECT GroupName, Name, Tel, Email From Employee
	INNER JOIN GroupDetail ON Employee.EmployeeID = GroupDetail.EmloyeeID
	INNER JOIN Group1 ON Group1.GroupID = GroupDetail.GroupID
	INNER JOIN Project ON Project.ProjectID = Group1.ProjectID

--f. Liệt kê tất cả nhân viên dự kiến sẽ được phân vào các nhóm làm việc
SELECT Status, Name FROM GroupDetail
	INNER JOIN Employee ON Employee.EmployeeID = GroupDetail.EmloyeeID
	WHERE Status = 'Chua Lam'

--g. Liệt kê tất cả thông tin về nhân viên, nhóm làm việc, dự án của những dự án đã hoàn thành
SELECT Status, GroupName, ProjectName, EnDDate FROM Employee
	INNER JOIN GroupDetail ON GroupDetail.EmloyeeID = Employee.EmployeeID
	INNER JOIN Group1 ON Group1.GroupID = GroupDetail.GroupID
	INNER JOIN Project ON Project.ProjectID = Group1.ProjectID
	WHERE Status = 'Da Xong'

--4. Viết câu lệnh kiểm tra:
--a. Ngày hoàn thành dự án phải sau ngày bắt đầu dự án
ALTER TABLE Project ADD CONSTRAINT Check_Ngaybatdau CHECK (StartDate < EndDate)

--b. Trường tên nhân viên không được null
SELECT * FROM Employee
WHERE EmployeeID IS NOT NULL

--c. Trường trạng thái làm việc chỉ nhận một trong 3 giá trị: inprogress, pending, done
ALTER TABLE  GroupDetail ADD CONSTRAINT Check_trangthai CHECK (Status IN ('Da Xong', 'Chua Lam', 'Dang Lam'))

--d. Trường giá trị dự án phải lớn hơn 1000
ALTER TABLE Project ADD CONSTRAINT Check_money CHECK (Cost > 1000)

--e. Trưởng nhóm làm việc phải là nhân viên


--f. Trường điện thoại của nhân viên chỉ được nhập số và phải bắt đầu bằng số 0
ALTER TABLE Group1 ADD CONSTRAINT fk_ldid FOREIGN KEY (LeaderID) REFERENCES Employee(EmployeeID)

--5. Tạo các thủ tục lưu trữ thực hiện:
--a. Tăng giá thêm 10% của các dự án có tổng giá trị nhỏ hơn 2000
UPDATE Project
SET Cost = Cost * 10 FROM Project
WHERE Cost <= 2000

--b. Hiển thị thông tin về dự án sắp được thực hiện
SELECT  GroupName,EmloyeeID, ProjectName, StartDate, EndDate, Cost FROM Project
	INNER JOIN Group1 ON Group1.ProjectID = Project.ProjectID
	INNER JOIN GroupDetail ON Group1.GroupID = GroupDetail.GroupID
WHERE Status = 'Chua Lam'

--c. Hiển thị tất cả các thông tin liên quan về các dự án đã hoàn thành
SELECT  GroupName,EmloyeeID, ProjectName, StartDate, EndDate, Cost FROM Project
	INNER JOIN Group1 ON Group1.ProjectID = Project.ProjectID
	INNER JOIN GroupDetail ON Group1.GroupID = GroupDetail.GroupID
WHERE Status = 'Da Xong'

--6. Tạo các chỉ mục:
--a. Tạo chỉ mục duy nhất tên là IX_Group trên 2 trường GroupID và EmployeeID của bảng
--GroupDetail
CREATE INDEX IX_Group ON GroupDetail(GroupID, EmloyeeID)

--b. Tạo chỉ mục tên là IX_Project trên trường ProjectName của bảng Project gồm các trường
--StartDate và EndDate
CREATE INDEX IX_Project ON Project(ProjectName, StartDate, EndDate)

--7. Tạo các khung nhìn để
--a. Liệt kê thông tin về nhân viên, nhóm làm việc có dự án đang thực hiện
CREATE VIEW IX_TTNVN AS
SELECT Name, Tel, Email, GroupName, ProjectName, StartDate, EndDate FROM Employee
	INNER JOIN GroupDetail ON GroupDetail.EmloyeeID = Employee.EmployeeID
	INNER JOIN Group1 ON Group1.GroupID = GroupDetail.GroupID
	INNER JOIN Project ON Project.ProjectID = Group1.ProjectID
	WHERE Status = 'Dang Lam'
SELECT * FROM IX_TTNVN

--b. Tạo khung nhìn chứa các dữ liệu sau: tên Nhân viên, tên Nhóm, tên Dự án và trạng thái làm
--việc của Nhân viên.
CREATE VIEW VIEW_nvnda AS
SELECT Name, GroupName, ProjectName, Status FROM Employee
	INNER JOIN GroupDetail ON GroupDetail.EmloyeeID = Employee.EmployeeID
	INNER JOIN Group1 ON Group1.GroupID = GroupDetail.GroupID
	INNER JOIN Project ON Project.ProjectID = Group1.ProjectID
SELECT * FROM VIEW_nvnda

--8. Tạo Trigger thực hiện công việc sau:
--a. Khi trường EndDate được cập nhật thì tự động tính toán tổng thời gian hoàn thành dự án và
--cập nhật vào trường Period
CREATE TRIGGER UTG_Project ON Project FOR UPDATE 
AS
IF EXISTS (SELECT EndDate FROM inserted WHERE EndDate >= StartDate)
BEGIN
SELECT EndDate From INSERTED UPDATE Project
SET Period = DATEDIFF(year, StartDate, EndDate)
END
ELSE
BEGIN
	PRINT 'ERRO'
	ROLLBACK TRAN
END
SELECT * FROM Project
INSERT INTO Project VALUES (456, 'Chinh Phu', '2012-1-1', '2022-1-1', 10, 1000)
--b. Đảm bảo rằng khi xóa một Group thì tất cả những bản ghi có liên quan trong bảng
--GroupDetail cũng sẽ bị xóa theo.
CREATE TRIGGER Trigger_Group ON Group1 FOR DELETE 
AS
DELETE FROM GroupDetail
WHERE GroupID IN (SELECT GroupID FROM DELETED)
SELECT * FROM GroupDetail
DROP TRIGGER UTG_Group

--c. Không cho phép chèn 2 nhóm có cùng tên vào trong bảng Group.
CREATE TRIGGER Trigger_Group1 ON Group1 FOR UPDATE
AS
IF EXISTS (SELECT GroupName FROM INSERTED WHERE GroupName IN (SELECT GroupName FROM Group1))
BEGIN
PRINT 'ERRO'
ROLLBACK TRAN
END
DROP TRIGGER Trigger_Group1
SELECT * FROM Group1