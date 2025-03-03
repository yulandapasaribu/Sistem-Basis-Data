
-- Exercise 1: CASE..END statement
USE Northwind
SELECT ProductName, CategoryName, UnitPrice
FROM Products INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID;

select * from Products
select * from Categories

-- Tanpa Menggunakan Deklarasi Variabel
-- Case�End statement
SELECT ProductName, CategoryName,
CASE
    WHEN UnitPrice IS NULL THEN 'Not Yet Priced'
    WHEN UnitPrice <= 50 THEN 'Cheap Product'
	WHEN UnitPrice > 50 AND UnitPrice <= 150 THEN 'Medium'
    ELSE 'Expensive'
END AS Price_Category
FROM Products INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID
ORDER BY UnitPrice;

-- Menggunakan deklarasi variabel
DECLARE @PriceCategory VARCHAR(50);

SELECT @PriceCategory =
    CASE
        WHEN UnitPrice IS NULL THEN 'Not Yet Priced'
        WHEN UnitPrice <= 50 THEN 'Cheap Product'
        WHEN UnitPrice > 50 AND UnitPrice <= 150 THEN 'Medium'
        ELSE 'Expensive'
	END
FROM Products;

SELECT ProductName, CategoryName, @PriceCategory AS Price_Category
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
ORDER BY UnitPrice;


-- Exercise 2 Task-1 : IF�THEN�ELSE�Statement
USE TennisDB;
DECLARE @CharTown Char(1), @Town Char(11);
SET @CharTown = 'E';
SET @Town = 
CASE @CharTown
	WHEN 'S' THEN 'Stratford'
	WHEN 'I' THEN 'Inglewood' 
	WHEN 'E' THEN 'Eltham'
	WHEN 'M' THEN 'Midhurst'
	WHEN 'D' THEN 'Douglas'
END;
SELECT * FROM PLAYERS 
WHERE TOWN = @Town;

-- Modify the SQL statement above using IF�Then�Else�.Statement.
USE TennisDB;
DECLARE @CharTown Char(1), @Town Char(11);
SET @CharTown = 'E';
SET @Town =
	CASE @CharTown
		WHEN 'S' THEN 'Stratford'
		WHEN 'I' THEN 'Inglewood'
		WHEN 'E' THEN 'Eltham'
		WHEN 'M' THEN 'Midhurst'
		WHEN 'D' THEN 'Douglas'
	END
IF  @Chartown= 'E'
	SELECT * FROM PLAYERS WHERE TOWN = @Town;
ELSE
	SELECT * FROM PLAYERS;

-- Task-2 Use TennisDB Database
-- In Grid																			
USE TennisDB
SELECT P.PLAYERNO, P.NAME, COUNT (m.WON) AS NR_WON
FROM PLAYERS P
INNER JOIN MATCHES m
ON P.PLAYERNO = m.PLAYERNO
GROUP BY p.PLAYERNO, p.NAME
HAVING COUNT (m.WON) > 2

-- Not in grid
USE TennisDB;
DECLARE 
@playerno VARCHAR(20), 
@playername VARCHAR(20), 
@nrwon VARCHAR(20);
SELECT @playerno=p.PLAYERNO, @playername=p.NAME, @nrwon=COUNT(m.PLAYERNO) FROM PLAYERS p
INNER JOIN MATCHES m
ON p.PLAYERNO=m.PLAYERNO
GROUP BY p.PLAYERNO, p.NAME
HAVING COUNT(m.PLAYERNO)>1
ORDER BY COUNT(m.PLAYERNO) ASC;
PRINT 'Player Number adalah '+@playerno+' dengan Player Name '+@playername+' NR_WON adalah '+@nrwon;


-- Exercise 3: While...Statement

USE AdventureWorksLT2008; 
SELECT * FROM SalesLT.Product;

-- Then, find the average of ListPrice:

SELECT AVG (ListPrice) FROM SalesLT.Product;

-- Consider the condition below and use while to build PL/SQL 
-- statement for the condition

WHILE (SELECT AVG(ListPrice) 
FROM SalesLT.Product) < $1000
BEGIN 
UPDATE SalesLT.Product
SET ListPrice = ListPrice * 2
SELECT MAX(ListPrice) 
FROM SalesLT.Product
	IF(SELECT MAX(ListPrice) 
FROM SalesLT.Product) <=$4000
BREAK
	ELSE 
CONTINUE
END



 












