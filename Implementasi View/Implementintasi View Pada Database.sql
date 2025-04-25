
-- CREATE VIEW FROM TASK W06S02-Query_Multiple_Table

-- Task 1 
-- Sintaks ini membuat view dengan nama `vLEFTJOIN_PLAY` 
-- yang akan menampilkan nomor pemain (`PLAYERNO`) dan nama (`NAME`) dari tabel `PLAYERS` di mana pemain tersebut 
-- tidak memiliki pertandingan yang sesuai dalam tabel `MATCHES`. 
-- Dengan kata lain, view ini akan menampilkan daftar pemain yang belum pernah bermain dalam pertandingan apa pun.
CREATE VIEW vLEFTJOIN_PLAY AS
SELECT A.PLAYERNO, A.NAME 
FROM  PLAYERS A
LEFT JOIN MATCHES B 
ON A.PLAYERNO = B.PLAYERNO
WHERE MATCHNO IS NULL;

SELECT * FROM vLEFTJOIN_PLAY;

-- Task 2
-- Sintaks ini membuat view dengan nama `vINNERJOIN_PLAY` 
-- yang menampilkan nomor pemain (`PLAYERNO`), nama pemain (`NAME`), dan total jumlah denda (`TOTAL_AMOUNT`) 
-- yang digabungkan (INNER JOIN) dari tabel `PLAYERS` dan `PENALTIES`, dengan hasil dikelompokkan (GROUP BY) berdasarkan nomor pemain.
CREATE VIEW vINNERJOIN_PLAY AS
SELECT A.PLAYERNO, NAME ,SUM(AMOUNT) AS TOTAL_AMOUNT
FROM PLAYERS A 
INNER JOIN PENALTIES I
ON A.PLAYERNO = I.PLAYERNO 
GROUP BY A.PLAYERNO, NAME

SELECT * FROM vINNERJOIN_PLAY;

-- Task 3
-- Sintaks ini membuat view dengan nama 'vTOTAL_AMOUNT'
-- yang menampilkan menampilkan total jumlah denda (TOTAL_AMOUNT) 
-- dari tabel PENALTIES dan PLAYERS menggunakan INNER JOIN berdasarkan nomor pemain (PLAYERNO)
-- menggunakan WHERE untuk hanya mencakup pemain yang berasal dari kota 'Inglewood'. 
CREATE VIEW vTOTAL_AMOUNT AS
SELECT SUM(AMOUNT) AS TOTAL_AMOUNT
FROM PENALTIES P
INNER JOIN PLAYERS S
ON P.PLAYERNO = S.PLAYERNO
WHERE TOWN = 'Inglewood';

SELECT * FROM vTOTAL_AMOUNT;

-- Task-4
-- Sintaks ini membuat view dengan nama 'vSUM_AMOUNT'
-- yang menampilkan nomor pemain (PLAYERNO), nama (NAME), dan total jumlah denda (TOTAL_AMOUNT)
-- dari tabel PENALTIES dan PLAYERS menggunakan INNER JOIN dengan hasil dikelompokkan berdasarkan nomor pemain dan nama.
-- Selain itu, hanya data yang memiliki jumlah denda lebih dari 100 yang akan dimasukkan ke dalam view.
CREATE VIEW vSUM_AMOUNT AS
SELECT O.PLAYERNO, NAME, SUM(AMOUNT) AS TOTAL_AMOUNT
FROM PLAYERS O
INNER JOIN PENALTIES S
ON O.PLAYERNO = S.PLAYERNO
GROUP BY O.PLAYERNO, NAME
HAVING SUM(AMOUNT) > 100

SELECT * FROM vSUM_AMOUNT;

-- Task-5
-- Sintaks ini membuat view dengan nama 'vDIVISION'
-- yang menampilkan nomor tim (TEAMNO), nomor pertandingan (MATCHNO), dan total jumlah kemenangan (TOTAL_WON)
-- dari tabel MATCHES dan TEAMS menggunakan INNER JOIN dengan hasil dikelompokkan berdasarkan nomor tim dan nomor pertandingan.
-- Selain itu, hanya data yang berasal dari divisi 'first' yang akan dimasukkan ke dalam view.
CREATE VIEW vDIVISION AS
SELECT E.TEAMNO, E.MATCHNO, WON TOTAL_WON 
FROM MATCHES E
INNER JOIN TEAMS S
ON E.TEAMNO = S.TEAMNO
WHERE S.DIVISION like 'first'

SELECT * FROM vDIVISION;

-- Task-6
-- Sintaks ini membuat view dengan nama 'vPENALTIES_COUNT'
-- yang menampilkan nama pemain (NAME), inisial (INITIALS), dan total jumlah pelanggaran (PENALTIES_COUNT)
-- dari tabel PLAYERS dan PENALTIES menggunakan RIGHT JOIN dengan hasil dikelompokkan berdasarkan nama pemain dan inisial.
-- Hanya data yang memiliki lebih dari satu pelanggaran yang akan dimasukkan ke dalam view.
CREATE VIEW vPENALTIES_COUNT AS
SELECT A.NAME, A.INITIALS, COUNT(PS.PLAYERNO) PENALTIES_COUNT
FROM PLAYERS A
RIGHT JOIN PENALTIES PS
ON A.PLAYERNO = PS.PLAYERNO
GROUP BY A.NAME, A.INITIALS
HAVING COUNT(PS.PLAYERNO) > 1

SELECT * FROM vPENALTIES_COUNT;

-- Task-7
-- Sintaks ini membuat view dengan nama 'vPS_AMOUNT'
-- yang menampilkan nama pemain (NAME), inisial (INITIALS), jumlah total pelanggaran (TOTAL PENALTIES), dan jumlah denda (AMOUNT)
-- dari tabel PLAYERS dan PENALTIES menggunakan INNER JOIN dengan hasil dikelompokkan berdasarkan nama pemain, inisial, dan jumlah denda.
-- Hanya data yang memiliki jumlah denda lebih dari 40 yang akan dimasukkan ke dalam view.
CREATE VIEW vPS_AMOUNT AS
SELECT A.NAME,A.INITIALS, COUNT(PS.PLAYERNO) 'TOTAL PENALTIES', PS.AMOUNT
FROM PLAYERS A
INNER JOIN PENALTIES PS
ON A.PLAYERNO = PS.PLAYERNO
GROUP BY  A.NAME,A.INITIALS, PS.AMOUNT
HAVING PS.AMOUNT > 40

SELECT * FROM vPS_AMOUNT;

-- Task-8
-- Sintaks ini membuat view dengan nama 'vP_TOWN'
-- yang menampilkan kota (TOWN) dan rata-rata jumlah pemain (AVG)
-- dari tabel PLAYERS menggunakan GROUP BY pada kota.
-- Data yang ditampilkan adalah jumlah pemain di setiap kota.
CREATE VIEW vP_TOWN AS 
SELECT TOWN , COUNT(TOWN) AVG
FROM PLAYERS 
GROUP BY TOWN

SELECT * FROM vP_TOWN

-- Task-9
-- Sintaks ini membuat view dengan nama 'vDIFF_AM'
-- yang menampilkan nomor pembayaran (PAYMENTNO), jumlah (AMOUNT), dan selisih antara jumlah dan rata-rata jumlah (Difference)
-- dari tabel PENALTIES dan rata-rata jumlah (AMOUNT) dari tabel PENALTIES.
-- Data yang ditampilkan adalah nomor pembayaran, jumlah, dan selisihnya antara jumlah dengan rata-rata.
CREATE VIEW vDIFF_AM AS
SELECT PAYMENTNO, AMOUNT, ABS(AMOUNT - (SELECT AVG(AMOUNT) FROM PENALTIES)) as Difference
FROM PENALTIES P
INNER JOIN PLAYERS S
ON P.PLAYERNO = S.PLAYERNO

SELECT * FROM vDIFF_AM;

-- Task-10
-- Sintaks ini membuat view dengan nama 'vNUMPLAY'
-- yang menampilkan nomor tim (TEAMNO) dan jumlah pemain (NUM_OF_PLAYERS)
-- dari tabel PLAYERS yang berasal dari kota 'Stratford' dan memiliki setidaknya satu kemenangan dalam pertandingan.
-- Data yang ditampilkan adalah nomor tim dan jumlah pemain.
CREATE VIEW vNUMPLAY AS
SELECT N.TEAMNO, COUNT(N.PLAYERNO) AS NUM_OF_PLAYERS FROM PLAYERS P
INNER JOIN MATCHES N
ON P.PLAYERNO = N.PLAYERNO
WHERE P.TOWN = 'Stratford' 
GROUP BY N.PLAYERNO, N.TEAMNO
HAVING SUM(N.WON) >= 1;

SELECT * FROM vNUMPLAY;