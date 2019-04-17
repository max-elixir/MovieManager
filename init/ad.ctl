LOAD DATA
INFILE ad.txt
APPEND
INTO TABLE ad
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(adId, title, runtime, in_house, profit, company)
