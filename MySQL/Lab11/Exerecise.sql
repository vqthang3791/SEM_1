CREATE DATABASE BTVNLab11
GO 
USE BTVNLab11
GO
CREATE TABLE Class (
	ClassCode varchar(10) PRIMARY KEY,
	HeadTeacher varchar(30),
	Room varchar(30),
	TimeSlot char,
	CloseDate datetime,
)
CREATE TABLE Student (
	RollNo varchar(10) PRIMARY KEY,
	ClassCode varchar(10),
	FullName varchar(30),
	Male bit,
	BirthDate datetime,
	Address varchar(30),
	Privice char(2),
	Email varchar(30)
	CONSTRAINT fk_Class FOREIGN KEY (ClassCode) REFERENCES Class(ClassCode)
)
CREATE TABLE Subject (
	SubjectCode varchar(10) PRIMARY KEY,
	SubjectName varchar(40),
	WMark bit,
	PMark bit,
	WTest_per int,
	Ptest_per int,
)
CREATE TABLE Mark (
	RollNo varchar(10),
	SubjectCode varchar(10),
	WMark float,
	PMark float,
	Mark float,
	CONSTRAINT pk_Mark PRIMARY KEY (RollNo, SubjectCode),
	CONSTRAINT fk_Student FOREIGN KEY (RollNo) REFERENCES Student(RollNo),
	CONSTRAINT fk_Subject FOREIGN KEY (SubjectCode) REFEREnCES Subject(SubjectCode)
)
INSERT INTO Class VALUES
('T2004M', 'DKThi', 'Class 207', 'G', '2022-1-12'),
('T2005N', 'ThiDK', 'Class 208', 'K', '2023-1-13'),
('T2006L', 'CoThi', 'Class 209', 'I', '2024-1-14'),
('T2007A', 'ThiD', 'Class 200', 'L', '2021-1-15'),
('T2004B', 'ThiK', 'Class 211', 'M', '2020-1-16')
INSERT INTO Student VALUES
('A1', 'T2004M', 'Nguyen Van A', '1', '1991-2-10', 'Thanh Xuan', 'HP', 'nguyenvana@gmail.com'),
('B1', 'T2005N', 'Nguyen Van B', '0', '1992-3-11', 'My Dinh', 'HN', 'nguyenvanb@gmail.com'),
('C1', 'T2006L', 'Nguyen Van C', '1', '1993-4-12', 'Doi Can', 'QN', 'nguyenvanc@gmail.com'),
('D1', 'T2007A', 'Nguyen Van D', '0', '1994-5-13', 'Nguyen Trai', 'TB', 'nguyenvandgmail.com'),
('E1', 'T2004B', 'Nguyen Van E', '1', '1995-6-14', 'Le Duan', 'ND', 'nguyenvane@gmail.com')
INSERT INTO Subject VALUES
('EPC', 'Elementary', 1, 1, 100, 100),
('ADD', 'Control', 1, 0, 1, 100),
('AAA', 'Java', 1, 1, 0, 0),
('BBB', 'Buff', 1, 0, 10, 100),
('CCC', 'Math', 1, 1, 10, 0),
('AE', 'Lentnd', 1, 0, 0, 100)
INSERT INTO Mark VALUES
('A1', 'EPC', 86, 90, 88),
('B1', 'ADD', 70, 76, 78),
('C1', 'AAA', 20, 30, 40),
('D1', 'CCC', 50, 60, 70),
('E1', 'AE', 21, 32, 43)
--1. Tạo một trigger cho thao tác INSERT của bảng Subject nhằm đảm bảo rằng sẽ không có 2 Subject
--có cùng tên.
CREATE TRIGGER check_subject 
ON Subject
FOR INSERT AS
IF EXISTS (SELECT SubjectCode FROM INSERTED WHERE SubjectCode IN (SELECT SubjectCode FROM subject))
BEGIN
	PRINT 'ERROR'
	ROLLBACK TRAN
END
SELECT * FROM subject 
DROP TRIGGER check_subject 
--2. Tạo một trigger cho bảng Student nhằm đảm bảo rằng giá trị của cột Privice phải bao gồm 2 kí
--tự khi ta tiến hành UPDATE.
CREATE TRIGGER UP_Student
ON Student
FOR UPDATE AS
IF ((SELECT Privice FROM Student) >= 2)
	BEGIN
	PRINT 'Privice = 2'
	ROLLBACK TRAN;
	END
SELECT * FROM Student
DROP TRIGGER UP_Student
UPDATE Student 
SET Privice = 'AM'
WHERE Male = 1
GO
--3. Tạo một trigger cho thao tác INSERT vào bảng Class nhằm đảm bảo rằng ký tự cuối cùng của
--trường TimeSlot sẽ là một trong các giá trị: G, I, M, L.
CREATE TRIGGER TS_Class
ON Class
FOR INSERT AS
IF ((SELECT TimeSlot FROM Class) = 'G', 'I', 'M', 'L')
SELECT * FROM Class
--4. Tạo một trigger cho bảng Subject nhằm đảm bảo khi ta xóa một Subject thì ta sẽ xóa hết tất cả các
--Mark liên quan đến Subject đó.
CREATE TRIGGER xoa_Subject ON subject
FOR DELETE AS
DELETE FROM MARK WHERE SubjectCode IN (SELECT SubjectCode FROM DELETED)
SELECT * FROM subject
--5. Tạo một trigger cho bảng Class để đảm bảo rằng khi ta xóa một Class thì ta sẽ xóa hết tất cả các
--Student thuộc Class đó, và tất nhiên là trước đó ta phải xóa tất cả các Mark của Student thuộc
--Class đang xóa.
CREATE TRIGGER xoa_class ON subject
FOR DELETE AS
DELETE FROM Class WHERE SubjectCode IN (SELECT SubjectCode FROM DELETED)
SELECT * FROM subject
--6. Tạo một trigger cho bảng Subject nhằm ngăn cản việc xóa các môn học đã có nhiều hơn 5 sinh
--viên dự thi. Những môn học có từ 5 sinh viên dự thi trở xuống thì có thể xóa, tuy nhiên cần phải
--thực hiện thao tác xóa các điểm thi của môn học này trước khi xóa nó.
CREATE TRIGGER ngancanxoa 
ON subject FOR DELETE AS
BEGIN
	DECLARE @kxoa INT
	SELECT @kxoa = COUNT(ROLLNO) FROM MARK WHERE SubjectCode IN ( SELECT SubjectCode FROM DELETED)
	BEGIN
		IF @kxoa > 5
		BEGIN
			PRINT 'k dc xoa'
			ROLLBACK TRAN
		END
		IF @kxoa <=5 
		BEGIN 
			IF EXISTS (SELECT * FROM Mark WHERE SubjectCode IN (SELECT SubjectCode FROM DELETED))
			BEGIN
				PRINT 'k dc xoa (mark)'
				ROLLBACK TRAN
			END
		END
	END
END
DROP TRIGGER ngancanxoa