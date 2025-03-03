-- Excercise 1 : Create a simple procedure with a simple select
USE TennisDB;

CREATE PROC Display_players
AS
SELECT DISTINCT NAME  
FROM players
WHERE NAME like '_o%'
ORDER BY NAME;

EXEC Display_players

-- Exercise 2: Create a simple procedure with a complex select

-- A
CREATE PROC Display_players_matches
AS
SELECT NAME, BIRTH_DATE, SUM(WON) AS TOTAL_WON FROM PLAYERS a
INNER JOIN MATCHES b 
ON a.PLAYERNO = b.PLAYERNO 
WHERE WON > LOST
GROUP BY a.NAME, a.BIRTH_DATE 
ORDER BY NAME, BIRTH_DATE

EXEC Display_players_matches;

-- B

CREATE PROC Display_Nortwind
AS
SELECT OrderID, ContactName, (LastName + FirstName) AS 'Employee Name', OrderDate, ShippedDate, S.CompanyName
FROM Orders O
INNER JOIN Customers C
ON O.CustomerID=C.CustomerID
INNER JOIN Employees E
ON O.EmployeeID=E.EmployeeID
INNER JOIN Shippers S
ON O.ShipVia=S.ShipperID;

EXEC Display_Nortwind

-- Exercise 3: Create a procedure to do insert, delete or update data

-- A
USE TennisDB;

-- Membuat sebuah prosedur dengan nama insert_with_player_parameter
CREATE PROCEDURE insert_with_player_parameter
(
	@playerno INT,
	@name CHAR (15),
	@initials CHAR(1),
	@birthdate DATE,
	@sex CHAR(1),
	@joined SMALLINT,
	@street VARCHAR(30),
	@houseno CHAR(4),
	@postcode CHAR(6),
	@town VARCHAR(30),
	@phoneno CHAR(13),
	@leagueno CHAR (4)
)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO PLAYERS(PLAYERNO, NAME, INITIALS, BIRTH_DATE, SEX, JOINED, STREET, HOUSENO, POSTCODE, TOWN, PHONENO, LEAGUENO)
	VALUES (@playerno, @name, @initials, @birthdate, @sex, @joined, @street, @houseno, @postcode, @town, @phoneno, @leagueno);
END;

-- Menginsert data
EXEC insert_with_player_parameter 
	@playerno = 71,
	@name = 'Yulanda Pasaribu',
	@initials = 'Y',
	@birthdate = '2004-06-23',
	@sex = 'M',
	@joined = 2010,
	@street = 'Pasar Borbor',
	@houseno = '70',
	@postcode = '1368AB',
	@town = 'Balige',
	@phoneno = '070-116927',
	@leagueno = '4567';

SELECT * FROM PLAYERS

-- B
drop procedure  DeletePlayer
CREATE PROCEDURE DeletePlayer @name CHAR (15) = null
AS
BEGIN
	IF @name is null
		SELECT * FROM PLAYERS
	ELSE
		DELETE FROM PLAYERS
		WHERE NAME = @name
END

Exec DeletePlayer -- Menampilkan data
Exec deletePlayer�'Baker' -- Mengahapus data atas nama Baker
SELECT * FROM PLAYERS -- Data untuk menampulkan bahwa nama Baker telah terhapus


-- Excercise 4

-- A
CREATE TABLE PerformanceIssue(
		ID INT identity NOT NULL,
		Status CHAR(1) NOT NULL
	);

-- PROCEDURE
CREATE PROCEDURE otherexcercise
		@TotalRecords INT
	AS
	BEGIN
		DECLARE @Counter INT = 1;

		WHILE @Counter <= @TotalRecords
		BEGIN
			INSERT INTO PerformanceIssue(Status)
			VALUES (CASE WHEN @Counter % 2 = 0 THEN 'A' ELSE 'B' END);

			SET @Counter = @Counter + 1;
		END
	END;

-- EKSEKUSI PROSEDUR
	EXEC otherexcercise @TotalRecords = 2000;

	select * from PerformanceIssue

-- B
-- Menampilkan nama tabel
CREATE PROC sp_viewTables 
AS 
SELECT * FROM INFORMATION_SCHEMA.TABLES 

sp_viewTables

-- Menampilkan nama kolom
CREATE PROC sp_viewColumns 
AS
SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
sp_viewColumns



