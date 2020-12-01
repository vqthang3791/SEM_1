CREATE DATABASE BOOK_STORE
GO
USE BOOK_STORE
GO
CREATE TABLE Customer (
	CustomerID int PRIMARY KEY IDENTITY,
	CustomerName varchar(50),
	Address varchar(100),
	Phon varchar(12),
)
CREATE TABLE Book (
	BookCode int PRIMARY KEY,
	Category varchar(50),
	Author varchar(50),
	Publisher varchar(50),
	Title varchar(100),
	Price int,
	InStore int,
)
CREATE TABLE BookSold (
	BookSoldID int PRIMARY KEY,
	CustomerID int,
	BookCode int,
	Date datetime,
	Price int,
	Amount int,
	CONSTRAINT fk_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
	CONSTRAINT fk_Book FOREIGN KEY (BookCode) REFERENCES Book(BookCode)
)

--1. Chèn ít nhất 5 bản ghi vào bảng Books, 5 bản ghi vào bảng Customer và 10 bản ghi vào bảng BookSold.
INSERT INTO Customer VALUES
(N'Hoàng Dược Sư', N'Đào Hoa Đảo', '1800 8198'),
(N'Doãn Chí Bình', N'Toàn Chân Giáo', '1900 8198'),
(N'Tiểu Long Nữ', N'Cổ Mộ Phái', '1800 9198'),
(N'Dương Quá', N'Cổ Mộ Phái', '1800 8118'),
(N'Trương Vô Kỵ', N'Minh Giáo Phái', '1880 8198')
INSERT INTO Book VALUES
(111, N'Kiếm Hiệp', N'Kim Dung', N'Kim Đồng', N'Tống Liêu Đại Chiến', 50, 11),
(112, N'Ngôn Tình', N'Cổ Long', N'Kim Đồng', N'Đạo Tặc Hái Hoa', 20, 12),
(113, N'Tiên Hiệp', N'Á Đông', N'Kim Đồng', N'Phi Thiên Thần Ký', 30, 13),
(114, N'Hài Hước', N'Lạp Trác', N'Kim Đồng', N'Cô Gái mét 52', 40, 14),
(115, N'Huyền Huyễn', N'Đình Tôn', N'Kim Đồng', N'Cô Gái Lầu Xanh', 60, 16)
INSERT INTO BookSold VALUES
(21, 1, 111, '1920-12-5', 15, 10),
(22, 2, 112, '1950-5-12', 15, 50),
(23, 3, 113, '1940-4-2', 15, 40),
(24, 4, 114, '1962-1-1', 15, 60),
(25, 5, 115, '1920-1-4', 15, 30)
--2. Tạo một khung nhìn chứa danh sách các cuốn sách (BookCode, Title, Price) kèm theo số lượng đã bán được của mỗi cuốn sách.
CREATE VIEW BookList AS
SELECT Book.BookCode, Title, Book.Price FROM Book
INNER JOIN BookSold ON BookSold.BookCode = Book.BookCode
--3. Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) kèm theo số lượng các cuốn sách mà khách hàng đó đã mua.
CREATE VIEW CustomerList AS
SELECT BookSold.CustomerID, Customer.CustomerName, Address FROM Customer
INNER JOIN Customer ON Customer.CustomerID = BookSold.CustomerID
--5. Tạo một khung nhìn chứa danh sách các khách hàng kèm theo tổng tiền mà mỗi khách hàng đã chi cho việc mua sách.
CREATE VIEW CustomerSumMoney AS
SELECT Customer.CustomerID, CustomerName, Price * Amount AS SUM_Money
FROM Customer INNER JOIN BookSold ON BookSold.CustomerID = Customer.CustomerID
SELECT * FROM CustomerSumMoney