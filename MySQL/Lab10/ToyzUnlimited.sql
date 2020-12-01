CREATE DATABASE ToyzUnlimited
GO
USE ToyzUnlimited
GO
CREATE TABLE ToyzUnlimited (
	ProductCode varchar(5) PRIMARY KEY,
	Name varchar(30),
	Category varchar(30),
	Manufacturer varchar(40),
	AgeRange varchar(15),
	UnitPrice money,
	Netweight int,
	QtyOnHand int,
)
DROP TABLE ToyzUnlimited
--1. Tạo bảng Toys với cấu trúc giống như trên. Thêm dữ liệu (15 bản ghi) vào bảng với giá trị của
--trường QtyOnHand ít nhất là 20 cho mỗi sản phẩm đồ chơi.
INSERT INTO ToyzUnlimited VALUES
(111, 'Sieu Nhan', 'Lap Ghep', 'NSX1', '3', '150', '500', '1'),
(112, 'Nguoi Nhen', 'Dat Ban', 'NSX2', '5', '120', '700', '2'),
(113, 'Ro Bot', 'Trung Bay', 'NSX3', '5', '130', '750', '3'),
(114, 'Logic', 'Tri Tue', 'NSX4', '4', '140', '150', '4'),
(115, 'Nau An', 'Mo Phong', 'NSX5', '6', '160', '250', '5'),
(116, 'Bac Si', 'Mo Phong', 'NSX6', '7', '150', '253', '1'),
(117, 'Ruby', 'Tri Tue', 'NSX7', '9', '170', '522', '2'),
(118, 'Oto', 'Lap Ghep', 'NSX8', '3', '180', '420', '3'),
(119, 'Xe May', 'Lap Ghep', 'NSX9', '5', '190', '650', '4'),
(120, 'Con Vat', 'Tri Tue', 'NSX10', '7', '250', '142', '1'),
(121, 'Chu Cai', 'Tri Tue', 'NSX11', '9', '350', '522', '2'),
(122, 'Que Tinh', 'Tri Tue', 'NSX12', '3', '450', '752', '3'),
(123, 'Sua Chua', 'Mo Hinh', 'NSX13', '5', '550', '885', '4'),
(124, 'Dat Nan', 'Mo Hinh', 'NSX14', '7', '650', '455', '5'),
(125, 'Sieu Nhan', 'Mo Hinh', 'NSX15', '9', '750', '650', '1')
--2. Viết câu lệnh tạo Thủ tục lưu trữ có tên là HeavyToys cho phép liệt kê tất cả các loại đồ chơi có
--trọng lượng lớn hơn 500g.
CREATE PROCEDURE HeavyToys AS 
SELECT * FROM ToyzUnlimited 
WHERE Netweight > 500
GO
DROP PROCEDURE HeavyToys
EXEC HeavyToys
--3. Viết câu lệnh tạo Thủ tục lưu trữ có tên là PriceIncreasecho phép tăng giá của tất cả các loại đồ
--chơi lên thêm 10 đơn vị giá.
CREATE PROCEDURE PriceIncreasecho AS
SELECT * FROM ToyzUnlimited
BEGIN
UPDATE ToyzUnlimited
SET UnitPrice *= 10
END
EXEC PriceIncreasecho
--4. Viết câu lệnh tạo Thủ tục lưu trữ có tên là QtyOnHand làm giảm số lượng đồ chơi còn trong của
--hàng mỗi thứ 5 đơn vị.
CREATE PROCEDURE QtyOnHand AS
SELECT * FROM ToyzUnlimited
BEGIN
UPDATE ToyzUnlimited
SET QtyOnHand /=1
END
EXEC QtyOnHand
--5. Thực thi 3 thủ tục lưu trữ trên.
EXEC HeavyToys
EXEC PriceIncreasecho
EXEC QtyOnHand
--Phần IV: Bài tập về nhà
--1. Ta đã có 3 thủ tục lưu trữ tên là HeavyToys,PriceIncrease, QtyOnHand. Viết các câu lệnh xem
--định nghĩa củacác thủ tục trên dùng 3 cách sau:
-- Thủ tục lưu trữ hệ thống sp_helptext
-- Khung nhìn hệ thống sys.sql_modules
-- Hàm OBJECT_DEFINITION()
USE ToyzUnlimited
GO
sp_help 'dbo.ToyzUnlimited'
sp_helptext '[dbo].[HeavyToys]'
sp_helptext '[dbo].[PriceIncreasecho]'
sp_helptext '[dbo].[QtyOnHand]'
SELECT definition FROM sys.sql_modules WHERE object_id=OBJECT_ID('HeavyToys')
SELECT definition FROM sys.sql_modules WHERE object_id=OBJECT_ID('PriceIncrease')
SELECT definition FROM sys.sql_modules WHERE object_id=OBJECT_ID('QtyOnHand')
SELECT OBJECT_DEFINITION(OBJECT_ID('HeavyToys'));
SELECT OBJECT_DEFINITION(OBJECT_ID('PriceIncrease'));
SELECT OBJECT_DEFINITION(OBJECT_ID('QtyOnHand'));
--2. Viết câu lệnh hiển thị các đối tượng phụ thuộc của mỗi thủ tục lưu trữ trên
EXEC sp_depends HeavyToys
EXEC sp_depends PriceIncreasecho
EXEC sp_depends QtyOnHand
--3. Chỉnh sửa thủ tục PriceIncreasevà QtyOnHandthêm câu lệnh cho phép hiển thị giá trị mới đã
--được cập nhật của các trường (UnitPrice,QtyOnHand).
ALTER PROCEDURE PriceIncrease as
UPDATE Toys SET UnitPrice = UnitPrice+15 
GO
ALTER PROCEDURE QtyOnHand AS
UPDATE ToyzUnlimited SET QtyOnHand = QtyOnHand-10
GO

--4. Viết câu lệnh tạo thủ tục lưu trữ có tên là SpecificPriceIncrease thực hiện cộng thêm tổng số sản
--phẩm (giá trị trường QtyOnHand)vào giá của sản phẩm đồ chơi tương ứng.
CREATE PROCEDURE SpecificPriceIncrease AS 
UPDATE ToyzUnlimited 
SET UnitPrice = UnitPrice+ QtyOnHand
GO
exec SpecificPriceIncrease
select* from ToyzUnlimited
--5. Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho thêm tính năng trả lại tổng số các bản ghi
--được cập nhật.
ALTER PROCEDURE SpecificPriceIncrease AS 
BEGIN 
UPDATE ToyzUnlimited SET UnitPrice = UnitPrice + QtyOnHand
SELECT ProductCode,Name, Category, ManuFacturer, UnitPrice AS Price, QtyOnHand 
FROM ToyzUnlimited
WHERE QtyOnHand > 0
SELECT @@ROWCOUNT
END
--6. Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho phép gọi thủ tục HeavyToysbên trong nó
ALTER PROCEDURE SpecificPriceIncrease AS
BEGIN
UPDATE ToyzUnlimited SET UnitPrice = UnitPrice + QtyOnHand
SELECT ProductCode, Name, UnitPrice as Price, QtyOnHand 
WHERE QtyOnHand > 0
SELECT @@ROWCOUNT
EXECUTE HeavyToys
END
EXEC SpecificPriceIncrease
--7. Thực hiện điều khiển xử lý lỗi cho tất cả các thủ tục lưu trữ được tạo ra.
SELECT ProductCode, Name, UniPrice, AS Price, QtyOnHand FROM ToyzUnlimited
WHERE QtyOnHand > 0
SELECT @number = @@ROWCOUNT
EXEC HeavyToys
--8. Xóa bỏ tất cả các thủ tục lưu trữ đã được tạo ra
DROP PROCEDURE HeavyToys
DROP PROCEDURE PriceIncreasecho
DROP PROCEDURE QtyOnHand