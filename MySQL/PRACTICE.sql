CREATE DATABASE MyBlog1
GO
USE MyBlog1
GO
CREATE TABLE Users (
	UserID int PRIMARY KEY IDENTITY,
	UserName varchar(20),
	Password varchar(30),
	Email varchar(30) UNIQUE,
	Address nvarchar(200),
)
CREATE TABLE Posts (
	PostID int PRIMARY KEY IDENTITY,
	Title nvarchar(200),
	Content nvarchar(200),
	Tag nvarchar(100),
	Status bit,
	CreateTime datetime DEFAULT (getdate()),
	UpdateTime datetime,
	UserID int,
	CONSTRAINT fk_user FOREIGN KEY (UserID) REFERENCES Users(UserID)
)
CREATE TABLE Comments (
	CommentID int PRIMARY KEY IDENTITY,
	Content nvarchar(500),
	Status bit,
	CreateTime datetime,
	Author nvarchar(30),
	Email varchar(50) NOT NULL,
	PostID int,
	CONSTRAINT fk_Post FOREIGN KEY (PostID) REFERENCES Posts(PostID)
)
--Write the script to do these tasks:
--1. Create the database, named it MyBlog. [1 mark]
--2. Create the tables [3 marks]
--3. Create a constraint (CHECK) to ensure value of Email column (on the Users table
--and the Comments table) always contain the ‘@’ character. [3 marks]
ALTER TABLE User1 ADD CONSTRAINT fk_checkemail CHECK(Email LIKE '%@%')
ALTER TABLE Comments ADD CONSTRAINT fk_checkcontents CHECK (Email LIKE '%@%')
--4. Create an unique, none-clustered index named IX_UserName on UserName column
--on table Users. [2 marks]
CREATE UNIQUE INDEX IX_UserName ON Users(UserName)
--5. Insert into above tables at least 3 records per table. [3 marks]
INSERT INTO Users VALUES
('Vinh', '1102', 'vinh@gmail.com', 'Ha Noi'),
('Vuong', '1020', 'vuong@gmail.com', 'Kham Thien'),
('Nhat', '1022', 'nhat@gmail.com', 'Thanh Tri')
SELECT * FROM Users
INSERT INTO Posts  VALUES
('An Gi Hnay', 'Ngon Qua', '#thang', 0, '2020/08/20', '2020/08/22', 1),
('hnay xem gi', 'thoi tiet', '#vuong', 1, '2020/08/18', '2020/08/23', 2),
('hnay uong gi', 'ruou oc', '#nhat', 1, '2020/08/15', '2020/08/24', 3)
SELECT * FROM Posts
INSERT INTO Comments VALUES
('cmt 1', 1, '2020/08/22', 'Le Van luyen', 'luyen@gmail.com', 1),
('cmt 2', 0, '2020/08/23', 'vu quang thang', 'vuquangthang@gmail.com', 1),
('cmt 3', 0, '2020/08/24', 'nguyen quang nhat', 'nguyenquangnhat@gmail.com', 2),
('cmt 4', 1, '2020/08/25', 'tran duc bo', 'tranducbo@gmail.com', 3)

--6. Create a query to select the postings has the ‘Social’ tag. [2 marks]
SELECT * FROM Posts
WHERE Tag = 'Social'

--7. Create a query to select the postings that have author who has ‘abc@gmail.com’
--email. [2 marks]
SELECT Posts.PostID, Posts.Title, Posts.Content, Comments.Email
FROM Posts
JOIN Comments ON Posts.PostID = Comments.PostID
WHERE Comments.Email = 'abc@gmail.com'

--8. Create a query to count the total comments of the posting. [2 marks]
SELECT Posts.PostID,COUNT(Comments.CommentID) AS COUNTED
FROM Posts
JOIN Comments ON Posts.PostID = Comments.PostID
GROUP BY Posts.PostID

--9. Create a view named v_NewPost, this view includes Title, UserName and
--CreateTime of two lastest posting. [2 marks]
CREATE VIEW V_NewPost 
AS
SELECT Title,UserName,CreateTime
FROM Users
JOIN Posts ON Users.UserID = Posts.UserID
ORDER BY CreateTime DESC

--10.Create a stored procedure named sp_GetComment that accepts PostID as given
--input parameter and display all comments of the posting. [3 marks]
CREATE PROC SP_GetComment 
@PostID int
AS
SELECT CommentID, Content,Status,CreateTime
FROM Comments 
WHERE PostID = @PostID

--11.Create a trigger nammed tg_UpdateTime to automatic update UpdateTime column
--in the Posts table to current time when the record in this table is updated. [2 marks]
CREATE TRIGGER TG_UpdateTime
ON Posts
FOR UPDATE
AS
BEGIN
	UPDATE Posts
	SET UpdateTime = GETDATE()
	WHERE PostID in ( SELECT PostID FROM DELETED)
END