-- Retrieve the movie titles that are rated PG-13 or R --
select title from film as f join movies as m 
on f.filmId = m.movieId where m.rating = 'PG-13' or m.rating = 'R');

-- Retrieve movie titles with a release date of 2 months --
def current_date = select current_date from dual;
def past = select add_months(sysdate,-2) from dual;

select title from film as f join movies as m 
on f.filmId = m.movieId where m.release_date >=
past and m.release_date <= current_date;

-- Retrieve commercials with similar genre and rating of movie --

