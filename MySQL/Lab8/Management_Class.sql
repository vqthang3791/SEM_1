CREATE DATABASE Management_Class
GO 
USE Management_Class
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
--1. Chèn ít nhất 5 bản ghi cho từng bảng ở trên.
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
INSERT INTO Student VALUES
('B2', 'T2004E', 'Le Thi B', '1', '1999-11-10', 'Thanh Oai', 'LS', 'lethib@gmail.com'),
('B3', 'T2004E', 'Le Thi C', '1', '1999-11-10', 'Binh Da', 'DL', 'lethic@gmail.com')
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
INSERT INTO Mark VALUES 
('A1', 'CF', 79,80, 79.5),
('C1','Buff', 67,80,73.5)
INSERT INTO Mark  VALUES 
('B1', 'EPC', 35, 56, 45.5),
('D1', 'Java1', 25, 65, 45)
INSERT INTO Mark VALUES
('B2', 'CF', 35, 55, 45),
('B2', 'Economic', 45,35, 40)
INSERT INTO Mark VALUES 
('B3', 'EPC', 35,45, 40),
('B3', 'Java1', 25,45, 35)
--2. Tạo một khung nhìn chứa danh sách các sinh viên đã có ít nhất 2 bài thi (2 môn học khác nhau).
CREATE VIEW List_Student_2test AS
SELECT DT.RollNo, HS.ClassCode, HS.FullName, COUNT(*) AS N'Đã Thi 2 Môn'
FROM Student AS HS
INNER JOIN Mark AS DT ON HS.RollNo = DT.RollNo GROUP BY DT.RollNo, HS.ClassCode, HS.FullName
HAVING COUNT(SubjectCode) > 1
-------
CREATE VIEW List_Student_2test2 AS
SELECT ClassCode, FullName FROM Student
WHERE RollNo IN (
	SELECT RollNo From Mark GROUP BY RollNo HAVING COUNT(SubjectCode) > 1
	)
SELECT * FROM List_Student_2test2
--3. Tạo một khung nhìn chứa danh sách tất cả các sinh viên đã bị trượt ít nhất là một môn.
CREATE VIEW Student_Exam_Faill AS
SELECT ClassCode, FullName AS SV_Thi_Truot FROM Student
WHERE RollNo IN (
	SELECT RollNo FROM Mark 
	WHERE Mark < 50
	)
--4.Tạo một khung nhìn chứa danh sách các sinh viên đang học ở TimeSlot G. 
CREATE VIEW Student_Study_TimeSlotG AS
SELECT ClassCode, FullName AS SV_TimeSlotG FROM Student
WHERE ClassCode IN (
	SELECT ClassCode FROM Class
	WHERE TimeSlot = 'G'
	)	
--5. Tạo một khung nhìn chứa danh sách các giáo viên có ít nhất 3 học sinh thi trượt ở bất cứ môn nào. 
CREATE VIEW Teacher_Student_Examfaill AS
SELECT HeadTeacher, Room FROM Class
WHERE ClassCode IN (
	SELECT ClassCode FROM Student_Exam_Faill GROUP BY ClassCode
	HAVING COUNT(SV_Thi_Truot) > 2
	)
SELECT * FROM Teacher_Student_Examfaill
--6. Tạo một khung nhìn chứa danh sách các sinh viên thi trượt môn EPC của từng lớp. Khung nhìn này phải chứa các cột: Tên sinh viên, Tên lớp, Tên Giáo viên, Điểm thi môn EPC.
CREATE VIEW Student_ExamFaill_EPC AS
SELECT FullName, Room, HeadTeacher, WMark, PMark, Mark FROM Student
INNER JOIN Class ON Class.ClassCode = Student.ClassCode
INNER JOIN Mark ON Mark.RollNo = Student.RollNo
WHERE SubjectCode = 'EPC' AND Mark < 50
SELECT * FROM Student_ExamFaill_EPC