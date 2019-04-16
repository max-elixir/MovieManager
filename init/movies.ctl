LOAD DATA
INFILE movies.txt
APPEND
INTO TABLE movies
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(movieId, release_date, expiration_date, rating)
