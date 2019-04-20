--1 New user to the database
insert into users values (42, 'newuser', 'badpassword', 'no', 'name', 'C');

--2 a particular ad isnt used anymore 
delete from ad where title = 'SA Film Festival';

--3 delete the old movies that cant be used
delete from movies where expiration_date <  to_date(sysdate);

--4 The theater is keeping a particular movie for an extra month
update movies set expiration_date=expiration_date+31 where movieId=0;

--5 - Project #3 is broken, so cancel the movies in that theater for the day
Update movie_schedule set is_showing=0 where room_num=3 and start_time>'26-APR-2019 01:00';
