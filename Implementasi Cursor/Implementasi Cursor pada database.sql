-- Excercise 1

-- (A) Print the first row as grid
-- Mendeklarasikan cursor
-- Terdapat query untuk menampilkan PLAYERNO, NAME, LEAGUENO dari tabel Players yang dimana 
-- data yang akan ditampilkan berdasarkan playerno paling besar (DESCENDING)
USE TennisDB -- Menggunakan database TennisDB
DECLARE players_cursor SCROLL CURSOR FOR
SELECT PLAYERNO, NAME, LEAGUENO
FROM PLAYERS
ORDER BY PLAYERNO DESC

-- Membuka cursor supaya dapat melakukan pemngambilan data dari setiap baris yang terdapat pada tabel
OPEN players_cursor

-- Membuat fetch untuk menampilkan data pertama berdasarkan DESCENDING
FETCH FIRST FROM players_cursor

-- Menutup cursor
CLOSE players_cursor
DEALLOCATE players_cursor


-- (B) Print the first row as text
-- Mendeklarasikan cursor
DECLARE players_cursor SCROLL CURSOR 
FOR 	
SELECT PLAYERNO, NAME, LEAGUENO
FROM PLAYERS
ORDER BY PLAYERNO DESC

-- Membuka cursor supaya dapat melakukan pemngambilan data dari setiap baris yang terdapat pada tabel
OPEN players_cursor

-- Mendeklarasikan sebuah variabel yang akan dipanggil ketika memprint output
DECLARE @PLAYERNO INT, @NAME VARCHAR(25), @LEAGUENO INT
FETCH LAST FROM players_cursor INTO @PLAYERNO, @NAME, @LEAGUENO
PRINT 'Player ' +  CAST(@PLAYERNO AS VARCHAR(5)) + 
' with name ' + rtrim(@NAME) + ' played in league no ' 
+ cast(@LEAGUENO AS VARCHAR(5))    

-- Menutup cursor
CLOSE players_cursor
DEALLOCATE players_cursor;

-- Excercise 2
-- Mendeklarasikan cursor
DECLARE players_town_cursor CURSOR 
FOR 	
SELECT PLAYERNO, NAME, TOWN
FROM PLAYERS
WHERE TOWN ='Stratford' OR TOWN ='Inglewood' OR TOWN ='Eltham'

-- Membuka cursor supaya dapat melakukan pemngambilan data dari setiap baris yang terdapat pada tabel
OPEN players_town_cursor

-- Mendeklarasikan beberapa variabel
DECLARE @PLAYERNO INT, @NAME VARCHAR(30), @TOWN VARCHAR(35)

-- Fetch untuk menampilkan data sesuai output pada soal
-- Data yang akan ditampilkan berdasarkan perintah print
FETCH NEXT FROM players_town_cursor INTO @PLAYERNO, @NAME, @TOWN
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @TOWN = 'Eltham'
	PRINT 'Player ' +  CAST(@PLAYERNO AS VARCHAR(15)) + 
	' with name ' + rtrim(@NAME) + ' lived in ' + rtrim(@TOWN) + ' town '
	FETCH NEXT FROM players_town_cursor INTO @PLAYERNO, @NAME, @TOWN
END

-- Menutup cursor
CLOSE players_town_cursor
DEALLOCATE players_town_cursor

-- Excercise 3
-- Mendeklarasikan cursor
-- Terdapat query untuk menampilkan data menggunakan inner join tabel Players dan Matches
-- dengan kondisi WON lebih besar dari LOST
DECLARE players_snd_cursor SCROLL CURSOR 
FOR
SELECT P.PLAYERNO, P.NAME, TEAMNO, WON, LOST
FROM PLAYERS P
INNER JOIN MATCHES M
ON P.PLAYERNO = M.PLAYERNO
WHERE WON > LOST

-- Membuka cursor supaya dapat melakukan pemngambilan data dari setiap baris yang terdapat pada tabel
OPEN players_snd_cursor

-- A.Menampilkan baris terakhir, maka FETCH nya menggunakan LAST
FETCH LAST FROM  players_snd_cursor

-- B.Menampilkan baris pertama, maka FETCH nya menggunakan FIRST
FETCH FIRST FROM  players_snd_cursor

-- C.Menampilkan baris ketiga, maka FETCH nya menggunakan ABSOLUTE 3
FETCH ABSOLUTE 3 FROM  players_snd_cursor

-- D.Menampilkan baris kedua dari cursor langkah pada bagian C, maka menggunakan RELATIVE 2
FETCH RELATIVE 2 FROM players_snd_cursor 

-- E.Menampilkan baris ketiga sebelum cursor pada langkah D, maka menggunakan RELATIVE -3
FETCH RELATIVE -3 FROM players_snd_cursor

-- Menutup cursor
CLOSE players_snd_cursor
DEALLOCATE players_snd_cursor

-- Excercise 4
-- Mendeklarasikan cursor
-- Terdapat query untuk menampilkan playerno, name, dan town dengan kondisi town(tempat tinggal)nya Eltham
DECLARE players_town_snd_cursor SCROLL CURSOR 
FOR 	
SELECT PLAYERNO, NAME, TOWN
FROM PLAYERS
WHERE TOWN ='Eltham'

-- Membuka cursor supaya dapat melakukan pemngambilan data dari setiap baris yang terdapat pada tabel
OPEN players_town_snd_cursor

-- Untuk presiden yang memiliki tempat tinggal di Eltham diganti menjadi Jakarta dengan sintaks UPDATE
UPDATE PLAYERS SET TOWN ='Jakarta'
WHERE TOWN='Eltham'

-- Mendeklarasikan sebuah variabel yang akan dipanggil ketika memprint output
DECLARE @PLAYERNO INT, @NAME VARCHAR(25), @TOWN VARCHAR(25)
FETCH FIRST FROM players_town_snd_cursor INTO @PLAYERNO, @NAME, @TOWN	
PRINT 'Player ' +  CAST(@PLAYERNO AS VARCHAR(5)) + ' with name ' + rtrim(@NAME) + ' lived in ' + rtrim(@TOWN)
FETCH NEXT FROM players_town_snd_cursor INTO @PLAYERNO, @NAME, @TOWN	
PRINT 'Player ' +  CAST(@PLAYERNO AS VARCHAR(5)) + ' with name ' + rtrim(@NAME) + ' lived in ' + rtrim(@TOWN)

-- Menutup cursor
CLOSE players_town_snd_cursor
DEALLOCATE players_town_snd_cursor

-- Excercise 5
USE Northwind;

-- Mendeklarasikan variabel
DECLARE @OrderID INT, @ProductID INT, @Quantity INT

-- Mendeklarasikan cursor dan query untuk menampilkan data
DECLARE exercise5_cursor CURSOR FOR 
SELECT od.OrderID, od.ProductID, od.Quantity
FROM [Order Details] od
INNER JOIN orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.ContactName = 'Maria Anders'
FOR UPDATE OF Quantity

-- Membuka cursor supaya dapat melakukan pemngambilan data dari setiap baris yang terdapat pada tabel
OPEN exercise5_cursor

DECLARE @OrderID INT, @ProductID INT, @Quantity INT
FETCH NEXT FROM exercise5_cursor INTO @OrderID, @ProductID, @Quantity 

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' untuk produk id ' + CAST(@ProductID AS NVARCHAR(10)) + ' dengan jumlah ' + CAST(@Quantity AS NVARCHAR(10)) 
IF @ProductID = 28 AND @Quantity < 10 
    BEGIN
        SET @Quantity = 10
        UPDATE [Order Details]
        SET Quantity = @Quantity
        WHERE CURRENT OF exercise5_cursor

        PRINT 'Jumlah produk yang di order untuk produk id '  + CAST(@ProductID AS NVARCHAR(10)) + ' telah diubah menjadi ' + CAST(@Quantity AS NVARCHAR(10))
    END

    FETCH NEXT FROM exercise5_cursor INTO @OrderID, @ProductID, @Quantity
END

-- Menutup cursor
CLOSE exercise5_cursor
DEALLOCATE exercise5_cursor


-- Excercise 6
-- Mendeklarasikan cursor
-- Terdapat query untuk menampilkan data
DECLARE Delete_Speedy CURSOR FOR
SELECT a.OrderID, a.CustomerID, b.CompanyName FROM Orders a 
INNER JOIN Shippers b ON b.ShipperID = a.ShipVia WHERE ShippedDate IS NULL

-- Membuka cursor supaya dapat melakukan pemngambilan data dari setiap baris yang terdapat pada tabel
OPEN Delete_Speedy

-- Mendeklarasikan beberapa variabel
DECLARE @CompanyName VARCHAR(50), @OrderID INT, @CustomerID VARCHAR(10)

-- Fetch untuk menampilkan data
FETCH NEXT FROM Delete_Speedy INTO @OrderID, @CustomerID, @CompanyName

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @CompanyName = 'Speedy Express'
	BEGIN
		DELETE FROM [Order Details] WHERE OrderID = @OrderID
		DELETE FROM Orders WHERE OrderID = @OrderID
		PRINT 'Order dengan order id ' + CAST(@OrderID AS VARCHAR(10)) +
		' telah dihapus dari tabel orders dan order details'
	END
	ELSE
	BEGIN
		PRINT 'Order ID : ' + CAST(@OrderID AS VARCHAR(10)) + ' untuk customer id ' +
		RTRIM(@CustomerID) + ' dengan jasa kurir ' + @CompanyName + ' belum dikirim' 
	END
	FETCH NEXT FROM Delete_Speedy INTO @OrderID, @CustomerID, @CompanyName
END

-- Menutup cursor
CLOSE Delete_Speedy
DEALLOCATE Delete_Speedy
