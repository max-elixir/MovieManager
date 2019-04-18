LOAD DATA
INFILE trailer_schedule.txt
APPEND
INTO TABLE trailer_schedule
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(trailerId, screenId, start_time TIMESTAMP "DD-MON-YYYY hh24:mi")
