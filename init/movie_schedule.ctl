LOAD DATA
INFILE movie_schedule.txt
INSERT
INTO TABLE movie_schedule
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(filmId, screenId, room_num, start_time, is_showing, showdate)
