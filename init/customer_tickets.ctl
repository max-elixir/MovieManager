LOAD DATA
INFILE customer_tickets.txt
INSERT
INTO TABLE customer_tickets
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(custId, screenId)
