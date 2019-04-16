LOAD DATA
INFILE film.txt
APPEND
INTO TABLE film
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(filmId, title, runtime, filmtype, genre, license_cost)
