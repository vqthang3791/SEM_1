CREATE DATABASE Lab13
DROP DATABASE Lab13
GO
USE AdventureWorks2019
GO
SELECT ProductID, Name, Color INTO Lab13.dbo.Product FROM Production.Product
GO
USE Lab13
GO
SELECT * FROM Product
CREATE TRIGGER UpdateProduct
ON Product
FOR UPDATE AS
BEGIN
	IF(UPDATE(Name))
	BEGIN
		PRINT 'Khong duoc phep thay doi ten san pham';
		ROLLBACK TRANSACTION;
	END
END
UPDATE Product 
SET Name = 'Cocacola'
WHERE ProductID = 1
--Tạo một INSERT trigger có tên là checkCustomerOnInsert cho bảng Customers. Trigger này có
--nhiệm vụ kiểm tra thao tác chèn dữ liệu cho bảng Customer, xem trường Phone có phải là null hay
--không, nếu trường Phone là null thì sẽ không cho tiến hành chèn dữ liệu vào bảng này. 
SELECT * FROM AdventureWorks2019.Sales.Customer
ALTER TABLE AdventureWorks2019.Sales.Customer ADD Phone char(10);
GO
SELECT CusTomerID, PersonID, StoreID, Phone INTO Lab13.dbo.Customer FROM AdventureWorks2019.Sales.Customer
GO
USE Lab13
GO
SELECT CusTomerID, PersonID, StoreID, Phone FROM Lab13.dbo.Customer
CREATE TRIGGER checkCustomerOnInsert
ON Customer
FOR INSERT AS
BEGIN
	IF ((SELECT Phone FROM Customer) is NULL)
	BEGIN
		PRINT 'Nhap So Dien Thoai';
		ROLLBACK TRANSACTION;
	END
END
DROP TRIGGER checkCustomerOnInsert
INSERT INTO Customer(CustomerID, PersonID, StoreID, Phone) VALUES ('3333', NULL, 3333, NULL)
SELECT * FROM Lab13.dbo.Customer
--2. Tạo một UPDATE trigger với tên là checkCustomerContryOnUpdate cho bảng Customers.
--Trigger này sẽ không cho phép người dùng thay đổi thông tin của những khách hàng mà có tên
--nước là France.
CREATE TRIGGER checkCustomerContryOnUpdate
ON Customer AS
IF UPDATE(Name)
BEGIN
IF EXISTS (SELECT Name FROM INSERTED WHERE Name =  'France')
PRINT 'EROR'
ROLLBACK TRAN
END
UPDATE Product 
SET Name = 'France'
WHERE ProductID = 1
SELECT * FROM Lab13.dbo.Customer
--3. Chèn thêm một cột mới có tên là Active vào bảng Customers và cài đặt giá trị mặc định cho nó là
--1. Tạo một trigger có tên là checkCustomerInsteadOfDelete nhằm chuyển giá trị của cột Active
--thành 0 thay vì tiến hành xóa dữ liệu thực sự ra khỏi bảng khi thao tác xóa dữ liệu được tiến hành
ALTER TABLE Lab13.dbo.Customer ADD Active varchar(50)
CREATE TRIGGER checkCustomerInsteadOfDelete ON Customer
FOR DELETE AS
UPDATE Customer
SET Active = 0 FROM DELETED
WHERE Customer.Active = DELETED.Active
--4. Thay đổi mức độ ưu tiên của trigger checkCustomerContryOnUpdate lên mức cao nhất. 
USE Lab13
GO
CREATE Trigger checkUPDATE ON Customer
FOR checkCustomerContryOnUpdate, checkCustomerInsteadOfDelete, checkCustomerOnInsert
--5. Tạo một trigger có tên safety nhằm vô hiệu hóa tất cả các thao tác: CREAT_TABLE,
--DROP_TABLE, ALTER_TABLE
DISABLE TRIGGER checkCustomerContryOnUpdate ON Customer
DISABLE TRIGGER checkCustomerInsteadOfDelete ON Customer
DISABLE TRIGGER checkCustomerOnInsert ON Customer
SELECT * FROM Customer
ENABLE TRIGGER checkCustomerContryOnUpdate ON Customer
ENABLE TRIGGER checkCustomerInsteadOfDelete ON Customer
ENABLE TRIGGER checkCustomerOnInsert ON Customer
--6. Xóa tất cả các trigger đã tạo. 
DROP Trigger checkUPDATE
DROP Trigger safety