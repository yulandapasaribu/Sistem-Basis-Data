
CREATE DATABASE Perpustakaan


CREATE TABLE Mahasiswa (
    Nim CHAR(10) PRIMARY KEY,
    Nama VARCHAR(30)
);


CREATE TABLE Buku (
    Id_buku CHAR(10) PRIMARY KEY,
    Penerbit VARCHAR(20),
    Deskripsi VARCHAR(50),
    StockAvailable INT
);


CREATE TABLE Transaksi (
	Nim CHAR (10),
	Id_Buku CHAR (10),
	Waktu_Pinjam DATETIME PRIMARY KEY,
	Waktu_Kembali DATETIME,
	Denda DECIMAL
);

-- Menambahkan constrain foreign key ke tabel Transaksi
ALTER TABLE Transaksi
ADD FOREIGN KEY (Nim) REFERENCES Mahasiswa(Nim);

-- Menambahkan constrain foreign key ke tabel Transaksi
ALTER TABLE Transaksi
ADD FOREIGN KEY (Id_Buku) REFERENCES Buku (Id_Buku);

SELECT * FROM Mahasiswa
INSERT INTO Mahasiswa (NIM, Nama) VALUES
    ('11422001', 'Yulanda Pasaribu'),
    ('11422002', 'Benyamin Sibarani'),
	('11422003', 'Juan A Sihombing'),
    ('11422004', 'Aldo Darel'),
    ('11422005', 'Rivael Sugianto Sagala'),
    ('11422006', 'Melvayana Artha Uli Manik'),
    ('11422007', 'Artha Margareth Sitorus'),
    ('11422008', 'Mutiara Enjelina'),
    ('11422009', 'Laura Vegawani Pasaribu'),
    ('11422010', 'David Kristian Silalahi');

SELECT * FROM Buku 
INSERT INTO Buku (Id_buku, Penerbit, Deskripsi, StockAvailable) VALUES
('B001', 'TechPub Co.', 'Pengantar Pemrograman Python', 50),
('B002', 'CodeCraft', 'Desain Interaksi Pengguna', 30),
('B003', 'Digital Insight', 'Pemahaman Dasar Jaringan Komputer', 25),
('B004', 'ByteKnowledge', 'Pengembangan Aplikasi Mobile dengan Flutter', 40),
('B005', 'IT Learning', 'Keamanan Informasi', 20),
('B006', 'InnovateTech', 'Mendalam ke Dunia Big Data', 35),
('B007', 'CloudPress', 'Implementasi Cloud Computing', 45),
('B008', 'Data Science', 'Analisis Data dengan Python', 15),
('B009', 'TechBook Nexus', 'Dasar-dasar Kecerdasan Buatan', 10),
('B010', 'CyberTech Publishing', 'Keamanan Sistem Informasi', 28);

SELECT * FROM Transaksi 
INSERT INTO Transaksi(Nim, Id_Buku, Waktu_Pinjam) 
VALUES 
	('11422001','B001','2021-10-01'),
	('11422002','B002','2021-10-02'),
	('11422003','B003','2021-10-03'),
	('11422004','B004','2021-10-04'),
	('11422005','B005','2021-10-05'),
	('11422006','B006','2021-10-06'),
	('11422007','B007','2021-10-07'),
	('11422008','B008','2021-10-08'),
	('11422009','B009','2021-10-09'),
	('11422010','B010','2021-10-10');

-- Tugas 1

-- Bagian A
CREATE TRIGGER tgr_insert
ON Transaksi
AFTER INSERT
AS
BEGIN
	DECLARE @id_buku CHAR(10)
	SELECT @id_buku = Id_Buku FROM inserted
	IF (SELECT stockavailable from buku WHERE Id_Buku = @id_buku) = 0
	BEGIN
		Print 'batal'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT 'berhasil'
		UPDATE buku SET StockAvailable = stockavailable-1
		WHERE Id_Buku = @id_buku
	END
END


SELECT * FROM Buku

-- Bagian B
CREATE TRIGGER trg_update
ON transaksi
AFTER UPDATE
AS
BEGIN
	DECLARE @time_kembali datetime, @id_buku CHAR(10)
	SELECT @time_kembali = Waktu_Kembali FROM inserted
	SELECT @id_buku = Id_Buku FROM inserted
	IF (SELECT stockavailable from buku WHERE Id_Buku = @id_buku) = @@ROWCOUNT
	BEGIN
		Print 'batal'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		Print 'berhasil'
		UPDATE buku SET StockAvailable = StockAvailable+1
		WHERE Id_Buku =@id_buku
	END
END


Update Transaksi 
SET Waktu_Kembali = '2021-10-10', Denda = 5.000
WHERE Id_Buku='B010'

SELECT * FROM Buku
SELECT * FROM Transaksi



-- Tugas 2

CREATE TABLE T_Tabungan (
    TabID CHAR(10) PRIMARY KEY,
    Saldo DOUBLE PRECISION
);

CREATE TABLE T_Transaksi (
    TransID CHAR(10) PRIMARY KEY,
    TabID CHAR(10),
    TransDateTime TIMESTAMP,
    Amount DOUBLE PRECISION,
    Tipe CHAR(9)
);

-- Menambahkan constrain foreign key ke tabel T_Transaksi
ALTER TABLE T_Transaksi
ADD FOREIGN KEY (TabID) REFERENCES T_Tabungan(TabID);


-- Insert data ke T_Tabungan
SELECT * FROM T_Tabungan
INSERT INTO T_Tabungan (TabID, Saldo) VALUES
('Tab001', 1000.00),
('Tab002', 1500.00),
('Tab003', 2000.00),
('Tab004', 800.00),
('Tab005', 3000.00);


-- Insert data ke T_Transaksi
SELECT * FROM T_Transaksi
INSERT INTO T_Transaksi (TransID, TabID, TransDateTime, Amount, Tipe) VALUES
('Trans001', 'Tab001', DEFAULT, 200.00, 'Withdraw'),
('Trans002', 'Tab002', DEFAULT, 500.00, 'Transfer'),
('Trans003', 'Tab003', DEFAULT, 100.00, 'Withdraw'),
('Trans004', 'Tab004', DEFAULT, 300.00, 'Transfer'),
('Trans005', 'Tab005', DEFAULT, 50.00, 'Withdraw');
   

-- CREATE TRIGGER trg_Saldo_Tabungan
CREATE TRIGGER trg_SaldoTabungan
ON T_Transaksi
AFTER UPDATE, INSERT
AS
BEGIN 
DECLARE @tabID CHAR(10), @amount DOUBLE PRECISION
	SELECT @tabID = TabID FROM inserted
	SELECT @amount = Amount FROM inserted
	IF((SELECT Tipe FROM inserted) LIKE 'Penarikan')
	BEGIN
		IF((SELECT Saldo FROM T_Tabungan WHERE TabID = @tabID) < @amount)
		BEGIN
			PRINT 'Penarikan tidak dapat dilakukan, saldo tidak mencukupi!'
			ROLLBACK TRAN
		END
		ELSE
		BEGIN
			UPDATE T_Tabungan SET Saldo = (Saldo - @amount) WHERE TabID = @tabID
			PRINT 'Penarikan berhasil'
	END
	END
	ELSE
	BEGIN
		UPDATE T_Tabungan SET Saldo = (Saldo + @amount) WHERE TabID = @tabID
		PRINT 'Setoran berhasil dilakukan'
	END
END


SELECT * FROM T_Transaksi
SELECT * FROM T_Tabungan


