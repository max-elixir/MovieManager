LOAD DATA
INFILE ad.txt
INSERT
INTO TABLE ad
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(adId, title, runtime, in_house, ad_type, company, profit)
