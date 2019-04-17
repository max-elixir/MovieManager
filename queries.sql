-- global variables --
def today = select current_date from dual;

-- 1. Retrieve the movie titles that are rated PG-13 or R --
select title from film f join movies m 
on f.filmId = m.movieId where m.rating = 'PG-13' or m.rating = 'R');

-- 2. Retrieve movie titles with a release date of 2 months --
def past = select add_months(sysdate,-2) from dual;

select title from film f join movies m 
on f.filmId = m.movieId where m.release_date >=
past and m.release_date <= today;

-- 3. Schedule the trailer for spider-man to play during the pre-screening of Hellboy --
def spider_man = select filmId from film where title = 'Spiderman: Far From Home' and filmtype = 'trailer';

def hellboy = select screenId from movie_schedule ms join film f on f.filmId = ms.filmId
where f.title = 'Hellboy (2019)' and f.filmtype = 'movie';

def movie_start_time = select current_timestamp from dual;

insert into trailer_schedule (trailerId, screenId) values(spider_man, hellboy, movie_start_time - 1);

-- 4. Calculate total cost of displaying superheros movies --
select sum(license_cost) from film f where genre = 'superhero' group by genre;

-- 5. Retrieve movie titles released before April of 2019 with a 4 - 5 star rating --
select title from film f join movies m on f.filmId = m.movieId
where f.release_date < '01-APR-19' and f.rating between 4 and 5;

-- 6. Retrieve all movies playing in room 3 today --
select title from film f join movie_schedule ms on f.filmId = ms.filmId 
where ms.room_num = 3 and f.filmtype='movie' and ms.start_time = today;

-- 7. Delete movies past expiration date --
delete from film f where f.filmId = (select m.movieId from movies m where 
to_char(cast(m.expiration_date), 'DD-MM-YYYY') < to_char(cast(today), 'DD-MM-YYYY'));

-- 8. --

