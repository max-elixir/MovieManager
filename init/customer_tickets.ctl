LOAD DATA
INFILE customer_tickets.txt
APPEND
INTO TABLE customer_tickets
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(custId, screenId Terminated by Whitespace)
