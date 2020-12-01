
CREATE DATABASE Aptech
GO
USE Aptech
GO
CREATE TABLE Classes (
	ClassName char(6) UNIQUE, 
	Teacher varchar(30),
	TimeSlot varchar(30),
	Class int,
	Lab int,
)
DROP TABLE Classes
--1. Tạo an unique, clustered index tên là MyClusteredIndex trên trường ClassName với thuộc tính sau: Pad_index = on
CREATE CLUSTERED INDEX IX_ClassName ON Classes(ClassName) WITH (Pad_index = on, FillFactor = 70)
CREATE UNIQUE CLUSTERED INDEX IX_ClassName ON Classes(ClassName) WITH (Pad_index = on, FillFactor = 70, Ignore_Dup_Key = On)
--2. Tạo a nonclustered index tên là TeacherIndex trên trường Teacher
CREATE NONCLUSTERED INDEX TecharIndex ON Classes(Teacher)
--3. Xóa chỉ mục TeacherIndex
DROP INDEX TecharIndex ON Classes
--4. Tạo lại MyClusteredIndexvới các thuộc tính sau:DROP_EXISTING, ALLOW_ROW_LOCKS, ALLOW_PAGE_LOCKS= ON, MAXDOP = 2.
--(Tìm hiểu thêm về các thuộc tính trên)
CREATE UNIQUE CLUSTERED INDEX IX_ClassName ON Classes(ClassName) WITH (DROP_EXISTING = ON, ALLOW_PAGE_LOCKS = ON, MAXDOP = 2)
--5. Tạo một composite index tên là ClassLabIndex trên 2 trường Class và Lab.
CREATE INDEX Class_Lab_Index ON Classes(Class, Lab)
--6. Viết câu lệnh xem toàn bộ các chỉ mục của cơ sở dữ liệu Aptech.
CREATE STATISTICS ThongKe_Aptech ON Classes(ClassName) 
DBCC SHOW_STATISTICS (Classes, ClassName)






