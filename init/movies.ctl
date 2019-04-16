LOAD DATA
INFILE movies.txt
INSERT
INTO TABLE movies
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(movieId, release_date, expiration_date, rating)
