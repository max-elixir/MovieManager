create or replace package body movie_manager as
  procedure get_schedule
    (today in varchar2 default to_char(SYSDATE,'DD-MON-YYYY')) is
    cursor sched is 
      select f.title, f.genre, f.runtime, m.rating, ms.room_num, 
      to_char(ms.start_time, 'hh:mi AM') start_time
      from film f join movies m on f.filmId = m.movieId 
      join movie_schedule ms on m.movieId = ms.filmId 
      where TRUNC(ms.start_time) = TO_DATE(today, 'DD-MON-YYYY');

    sched_rec sched%rowtype;

  begin
    open sched;
    fetch sched into sched_rec;
    dbms_output.put_line('Schedule for '||today);

    -- print header --
    dbms_output.put_line('Title | Genre | Rating | Start Time | End Time |Room Number');

    while sched%found loop
      dbms_output.put_line(
        sched_rec.title||'|'||sched_rec.genre||'|'||sched_rec.rating||'|'||sched_rec.start_time||'|'|| '|'|| sched_rec.room_num);
      fetch sched into sched_rec;
    end loop;
    close sched;

    exception
      when others then
        dbms_output.put_line('Invalid date, please try again.');
  end;

procedure schedule_trailer (trailer in varchar2, screenId in integer, st in varchar2) is
  cursor pre_sched is 
    get_pre_schedule(screenId);

  trailerId integer;
  begin
    trailerId:= select t.filmId from trailer t, film f where t.title = trailer and f.filmtype = 'trailer';

    insert into trailer_schedule (trailerId, screenId, start_time) values(
    ,
    (select screenId from movie_schedule ms join film f on f.filmId = ms.filmId
    where f.title = 'Hellboy (2019)' and f.filmtype = 'movie'),
    (select current_timestamp from dual) - 1);
  end;

function get_pre_schedule(screenId in integer)
return 

/
show errors
