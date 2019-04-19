LOAD DATA
INFILE customer_tickets.txt
APPEND
INTO TABLE customer_tickets
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(custId, screenId, dateOfPurchase TIMESTAMP "DD-MON-YYYY hh24:mi")

