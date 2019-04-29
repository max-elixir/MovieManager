-- Procedure used to print the schedule of movies for a given date --
-- It is assumed day is a valid date type. --
create or replace procedure get_movies_for_today(day in date) is

  -- select movie name, genre, rating, room number, and start time of movies --	
declare 
  cursor c1 is
  select f.title, f.genre, f.runtime, m.rating, ms.room_num, ms.start_time 
  from film f join movies m on f.filmId = m.movieId 
  join movie_schedule ms on m.movieId = ms.filmId 
  where TRUNC(ms.start_time) = TO_DATE(day, 'DD-MON-YY');

  end_time varchar2(8);

-- get endtime of movie --
begin

 -- print header --
  dbms_output.put_line('Title')

  open c1;

  fetch c1 into c1_rec;

  while c1%found loop
    end_time = get_end_time(c1_rec.start_time, c1_rec.runtime);
    dbms_output.put_line()
    fetch c1 into c1_rec;



exception
  when date_is_wrong

end;

-- print table of schedule
