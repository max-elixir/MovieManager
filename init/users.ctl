LOAD DATA
INFILE users.txt
INSERT
INTO TABLE users
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(id, username, password, first_name, last_name, role)
