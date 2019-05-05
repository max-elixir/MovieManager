create or replace package body movie_manager as
  procedure get_schedule
    (today in varchar2 default to_char(SYSDATE,'DD-MON-YYYY')) is
  cursor sched is
    select * from film join movie_schedule on 
    film.filmId=movie_schedule.filmId join movies on 
    movies.movieId=film.filmId where movies.release_date=to_date(today,'DD-MON-YYYY');
  sched_rec sched%rowtype;
  startf varchar2(5);
  endf varchar2(5);
  begin
    open sched;
    fetch sched into sched_rec;
    dbms_output.put_line('Schedule for '||today);
    while sched%found loop
      startf:=to_char(sched_rec.start_time, 'HH24:Mi');
      endf:=get_endtime(sched_rec.start_time, sched_rec.runtime);
      dbms_output.put_line(
        sched_rec.title||' '||startf||' '||endf||' '||sched_rec.room_num);
      fetch sched into sched_rec;
    end loop;
    close sched;
  end;

  function get_endtime(start_time in timestamp, runtime in film.runtime%type)
  return varchar2 as endtime varchar2(30):=to_char(start_time);
    --as endtime timestamp:=start_time;
  hours number;
  minutes number;
  hold timestamp;
  begin
    hours:=trunc(runtime);
    minutes:=(runtime - hours)*10;
    hold:= to_timestamp(start_time);
    hold:=hold+ ((1/24)*hours);
    hold:=hold+ ((1/1440)*minutes);
    --dbms_output.put_line(start_time||' then ends at the time '||hold);
    endtime:= to_char(hold, 'hh24:mi');
    return endtime;
  end;
end;
/
show errors
