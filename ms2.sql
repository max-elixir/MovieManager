create or replace package body movie_manager as
  procedure get_schedule
    (today in varchar2 default to_char(SYSDATE,'DD-MON-YYYY')) is
  cursor sched is
    select * from film join movie_schedule on film.filmId=movie_schedule.filmId;
  sched_rec sched%rowtype;
  begin
    open sched;
    fetch sched into sched_rec;
    dbms_output.put_line('Schedule for '||today);
    while sched%found loop
      dbms_output.put_line(
        sched_rec.title||' '||sched_rec.start_time||' '||sched_rec.room_num);
      fetch sched into sched_rec;
    end loop;
    close sched;
  end;
end;
/
show errors
