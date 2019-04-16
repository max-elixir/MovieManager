LOAD DATA
INFILE ad_schedule.txt
APPEND
INTO TABLE ad_schedule
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(adId, screenId, start_time)
