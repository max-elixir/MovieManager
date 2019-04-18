
-- 1. Retrieve the movie titles that are rated PG-13 or R --
select title from film f join movies m 
on f.filmId = m.movieId where m.rating = 'PG-13' or m.rating = 'R';

-- 2. Retrieve movie titles with a release date of 2 months --
select title from film f join movies m 
on f.filmId = m.movieId where m.release_date >=
(select add_months(sysdate,-2) from dual)
and m.release_date <= (select current_date from dual);

-- 3. Schedule the trailer for spider-man to play during the pre-screening of Hellboy --
insert into trailer_schedule (trailerId, screenId, start_time) values(
    (select filmId from film where title = 'Spiderman: Far From Home' and filmtype = 'trailer'),
    (select screenId from movie_schedule ms join film f on f.filmId = ms.filmId
     where f.title = 'Hellboy (2019)' and f.filmtype = 'movie'),
    (select current_timestamp from dual) - 1);

-- 4. Calculate total cost of displaying superheros movies --
select sum(license_cost) from film f where genre = 'superhero' group by genre;

-- 5. Retrieve Rated R movie titles released before April of 2019 --
select title from film f join movies m on f.filmId = m.movieId
where m.release_date < '01-APR-19' and m.rating = 'R';

-- 6. Retrieve all movies playing in room 3 today --
select title from film f join movie_schedule ms on f.filmId = ms.filmId 
where ms.room_num = 3 and f.filmtype='movie' and ms.start_time = (select current_date from dual);

-- 7. Delete movies past the expiration date --
delete from film f where f.filmId = (select m.movieId from movies m where 
m.expiration_date < (select current_date from dual)

-- 8. Retrieve screenings with a total runtime longer than 2 hours --

-- 9. Retrieve customer names that have visted at least one screening in the last month --

-- 10. --