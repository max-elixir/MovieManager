LOAD DATA
INFILE movie_schedule.txt
APPEND
INTO TABLE movie_schedule
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(filmId, screenId, room_num, is_showing, start_time TIMESTAMP "DD-MON-YYYY hh24:mi")
