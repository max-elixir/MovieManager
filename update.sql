--1

--2

--3

--4 The theater is keeping a particular movie for a month
update movie set expiration_date+31 where movieId=0;

--5 - Project #3 is broken, so cancel the movies in that theater for the day
Update movie_schedule set is_showing=0 where room_num=3 and date='26-APR-2019';