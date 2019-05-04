create or replace package body movie_manager as
  procedure get_schedule
    (today in varchar2 default to_char(SYSDATE,'DD-MON-YYYY')) is
  cursor sched is
    select f.title, f.genre, f.runtime, m.rating, ms.room_num, 
    to_char(ms.start_time, 'hh.mi AM') start_time
    from film f join movies m on f.filmId = m.movieId 
    join movie_schedule ms on m.movieId = ms.filmId 
    where TRUNC(ms.start_time) = TO_DATE(today, 'DD-MON-YY');

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
  end;
end;
/
show errors
