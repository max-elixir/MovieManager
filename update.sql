-- 1 New user to the database --
insert into users values (42, 'newuser', 'badpassword', 'no', 'name', 'C');

-- 2 The 'SA Film Festival ad' ad isnt used anymore --
delete from ad where title = 'SA Film Festival';

-- 3 delete the old movies that cant be used --
delete from movies where expiration_date <  (select current_date from dual);

-- 4 The theater is keeping Hellboy for an extra month --
update movies set expiration_date=ADD_MONTHS(expiration_date, 1) 
where movieId = (select m.movieId from movies m, film f where m.movieId = f.filmId and f.title = 'Hellboy (2019)');

-- 5 Projector #3 is broken, so cancel the movies in that theater for the day --
Update movie_schedule set is_showing=0 where room_num=3 and start_time>'26-APR-2019 01:00';
