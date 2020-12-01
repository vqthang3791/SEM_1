--1. Bảng Tao
TẠO BẢNG tac_gia (
id int IDENTITY (1,1) PRIMary KEY,
ten Nvarchar (255) KHÔNG NULL UNIQUE
);
TẠO BẢNG loai_sach (
id int IDENTITY (1,1) PRIMary KEY,
ten Nvarchar (255) KHÔNG NULL UNIQUE
);
TẠO BẢNG nha_xuat_ban (
id int IDENTITY (1,1) PRIMary KEY,
ten Nvarchar (255) KHÔNG NULL UNIQUE,
dia_chi Nvarchar (255) KHÔNG NULL
);
CREATE TABLE sach (
id int IDENTITY (1,1) PRIMARY KEY,
ten Nvarchar (255) KHÔNG NULL,
tom_tat Ntext,
nam_xb int KHÔNG NULL CHECK (nam_xb> 1900),
lan_xb int KHÔNG NULL DEFAULT 1 CHECK (0)
gia_ban thập phân (16,0) KHÔNG NULL KIỂM TRA (gia_ban> = 0),
so_luong int NOT NULL KIỂM TRA (so_luong> = 0),
tacgia_id int NOT NULL FOREIGN KEY THAM KHẢO tac_gia (id),
loaisach_id int NOT NULL FOREIGN KEY THAM KHẢO loai_sach (id),
nxb_id int NOT NULL FOREIGN KEY THAM KHẢO nha_xuat_ban (id)
);
--2. Dữ liệu
INSERT INSERT INTO tac_gia (ten) VALUES ('Eran Katz');
XÁC NHẬN VÀO loai_sach (mười) GIÁ TRỊ (N'Khoa học phiên hội ');
XÁC NHẬN VÀO nha_xuat_ban (mười, dia_chi) GIÁ TRỊ (N'Tri Thức ', N'53 Nguyễn Du, Hai Bà Trưng, ​​Hà Nội');
INSERT INTO sach GIÁ TRỊ (N'Trí tuệ Do Thái', N'Bạn you like to known: Người Do Thái sáng tạo ra cái gì and the source gốc
? Trí tuệ their xuất phát từ đâu does not Cuốn sách will be dần hé lộ
those bí nam tính của bạn và người Do Thái, của một người nam
thông tuệ for those phương pháp and vực: điện lạnh phát triển tầng lớp trí
thức have been stored kín hàng nghìn năm like a bí ẩn mật mang tính
văn hóa ', 2010,1,79000,100,1,1,1).
--3. Liet ke
CHỌN * TỪ sach WHERE nam_xb> = 2008;
--4. Liet ke 10 cuon gia cao
CHỌN TOP 10 * TỪ sach ĐẶT HÀNG B BYNG gia DESC;
--5. Tim kiem 'tin hoc'
CHỌN * TỪ sach Ở đâu mười THÍCH '% tin hoc%';
--6. Liet ke bat dau chu T gia giam dan
CHỌN * TỪ sach Ở ĐÂU mười THÍCH 'T%' ĐẶT HÀNG CỦA gia DESC;
--7. Liet ke sach cua nxb tri thuc
CHỌN * TỪ sach WHERE nxb_id IN
(CHỌN id TỪ nha_xuat_ban WHERE ten THÍCH N'Tri phiên bản ');
--số 8.

(CHỌN nxb_id TỪ sach Ở ĐÂU mười THÍCH N'Trí tầm Do Thái ');
--9. Hiền thi ngày du thong tin sach
CHỌN sach.id, sach.ten như ten_sach, sach.nam_xb,
nha_xuat_ban.ten như ten_nxb, loai_sach.ten như loai_sach
TỪ sach
INNER JOIN nha_xuat_ban ON sach.nxb_id = nha_xuat_ban.id
INNER JOIN loai_sach ON sach.loaisach_id = loai_sach.id
--10. Tim sach dat nhat
CHỌN TOP 1 * TỪ sach ĐẶT HÀNG THEO gia_ban DESC;
--11. TIm sach so luong nhieu nhat
CHỌN TOP 1 * TỪ sach ĐẶT HÀNG B soNG so_luong DESC;
--12. Tim sach theo mười tac gia
CHỌN * TỪ sach WHERE tacgia_id IN
(CHỌN id TỪ tac_gia Ở ĐÂU mười THÍCH N'Eran Katz ');
--13. Giam gia 10% cac cuon sach <2008
CẬP NHẬT sach SET gia_ban = (gia_ban) * 0.9 WHERE nam_xb <= 2008;
--14. Thong ke sach cua cac NXB
CHỌN QUỐC GIA (*), nxb_id TỪ sach NHÓM THEO nxb_id;
- 15. Thong ke sach theo loai sach
CHỌN QUỐC GIA (*), loaisach_id TỪ sach NHÓM THEO loaisach_id;
--16. Đạt chi muc cho ten sach
TẠO INDEX tenach_index ON sach (ten);
--17. tao xem
CREATE VIEW sach_view AS
CHỌN sach.id, sach.ten như ten_sach, tac_gia.ten như tac_gia,
nha_xuat_ban.ten như nha_xuat_ban, sach.gia_ban
TỪ sach
INNER JOIN tac_gia ON sach.tacgia_id = tac_gia.id
INNER JOIN nha_xuat_ban ON sach .nxb_id = nha_xuat_ban.id
--18. Thủ tục Tao
- 18a.
CREATE PROCEDURE SP_Them_Sach @ten nvarchar (255), @ tomtat nvarchar,
@nam_xb int, @ lan_xb int, @ gia_ban thập phân (16,0), @ so_luong int,
@tacgia_id int, @ loaisach_id int, @ nxb_id int
AS
INSERT INTO sach GIÁ TRỊ (@ ten, @ tomtat, @ nam_xb, @ lan_xb,
@ gia_ban, @ so_luong, @ tacgia_id, @ loaisach_id, @ nxb_id);
--18b.
TẠO QUY TRÌNH SP_Tim_Sach @tu_khoa Nvarchar (255)
NHƯ
CHỌN * TỪ sach Ở đâu mười THÍCH '%' + @ tu_khoa + '%';
--18c.
TẠO QUY TRÌNH SP_Sach_ChuyenMuc @ma_chuyen_muc int
NHƯ
CHỌN * TỪ sach WHERE loaisach_id = @ma_chuyen_muc;
--19. Kích hoạt
TẠO TRIGGER khong_cho_xoa_sach TRÊN sach
ĐỂ XÓA
NHƯ
NẾU EXISTS (CHỌN * TỪ đã xóa WHERE so_luong> 0)
GIAO DỊCH ROLLBACK;
- 20. Kích hoạt
TẠO TRIGGER khong_cho_xoa_chuyen_muc TRÊN loai_sach
ĐỂ XÓA
NHƯ
NẾU EXIST (CHỌN * TỪ sach WHERE loaisach_id IN
(CHỌN id TỪ đã xóa)
)
GIAO DỊCH ROLLBACK;
