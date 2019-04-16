-- Retrieve the movie titles that are rated PG-13 or R --
select title from film as f join movies as m 
on f.filmId = m.movieId where m.rating = 'PG-13' or m.rating = 'R');

-- Retrieve movie titles with a release date of 2 months --
select title from film as f join movies as m 
on f.filmId = m.movieId where m.release_date = Date.currentTime() - 2 month time span



