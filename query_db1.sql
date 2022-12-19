-- CREATE DATABASE db_test
-- DROP DATABASE db_test
CREATE DATABASE db_company;
USE db_company;
CREATE TABLE bands (
	id INT NOT NULL AUTO_INCREMENT,
	col_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);
/** ALTER TABLE bands
RENAME COLUMN id TO bands_id; 
ALTER TABLE band
	ADD COLUMN test;
	DROP COLUMN test;
	RENAME to bands;
**/
CREATE TABLE albums (
	album_id INT NOT NULL AUTO_INCREMENT,
    album_name VARCHAR(255) NOT NULL,
    album_release_year INT,
    band_id INT NOT NULL,
    PRIMARY KEY (album_id),
    FOREIGN KEY (band_id) REFERENCES bands (band_id)
);

INSERT INTO bands (col_name)
VALUES ('Iron Maiden');

INSERT INTO bands (col_name)
VALUES ('Deuce'), ('Parokya ni Edgar'), ('Lily');

SELECT * FROM bands;
-- SELECT * FROM BANDS LIMIT 2;
-- SELECT col_name FROM bands;
SELECT band_id AS 'ID', band_name AS 'Band Name'
FROM bands;

-- DELETE FROM bands WHERE band_id IN (1,2,3);

SELECT * FROM bands ORDER BY band_name ASC;

INSERT INTO albums (album_name, album_release_year, band_id)
VALUES 	('The Number of the Beasts', 1985, 7),
		('Power Slave', 1984, 7),
        ('Nightmare', 2018, 4),
        ('Destination XYZ', 2005, 6),
        ('Welcome sa Parokya', 2012, 5),
        ('Test Album', NULL, 4);
        
INSERT INTO albums(album_name, album_release_year, band_id)
VALUES	('Destination XYZ', 2007, 5);
-- SELECT DISTINCT album_name FROM albums;

-- DELETE FROM albums WHERE album_id = 11;

INSERT INTO albums(album_name, album_release_year, band_id)
VALUES('test', 2012, 5);

UPDATE albums
SET album_release_year = 2006
WHERE album_id = 4;

SELECT * FROM albums;

SELECT * FROM albums WHERE album_release_year < 2000;

SELECT * FROM albums WHERE album_name LIKE '%er%' OR band_id = 2;

SELECT * FROM albums
WHERE album_release_year = 1984 AND band_id = 7 ;

SELECT * FROM albums
WHERE album_release_year BETWEEN 2000 AND 2018 ORDER BY album_release_year ASC;

SELECT * FROM albums
WHERE album_release_year IS NULL;

DELETE FROM albums WHERE album_id = 6;

/********JOINS***********************/

SELECT * FROM albums;
SELECT * FROM bands;-- 

SELECT * FROM bands
INNER JOIN albums ON bands.band_id = albums.band_id;
-- INNER JOIN return value that has a match on both tables

INSERT INTO bands(band_name)
VALUES ('Kamikazee');

SELECT * FROM bands
LEFT JOIN albums ON bands.band_id = albums.band_id; -- return all values from bands even no assoc values

SELECT * FROM bands
RIGHT JOIN albums ON albums.band_id = bands.band_id; -- return all values from albums even no assoc values

SELECT AVG(album_release_year) FROM albums;
SELECT SUM(album_release_year) FROM albums;

SELECT band_id, COUNT(band_id) FROM albums
GROUP BY band_id;

INSERT INTO albums (album_name, album_release_year, band_id)
VALUES	('FishEye', 2008, 6);

SELECT b.band_name AS 'Band Name', COUNT(a.band_id) as num_albums
FROM bands AS b
LEFT JOIN albums as a ON a.band_id = b.band_id
WHERE b.band_name = 'Deuce'
GROUP BY b.band_id
HAVING num_albums = 1;





