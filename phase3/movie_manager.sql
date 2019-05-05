create or replace package body movie_manager as

-- Used to print the schedule of movies for a given day --
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

-- Used to schedule a trailer for a given movie --
procedure schedule_trailer (trailerTitle in varchar2, screenId in integer, st in varchar2) is
  cursor pre_sched is 
    select * from table(get_pre_schedule(screenId));

  trailerId integer;
  start_time timestamp;

  begin
    declare
      invalid_time_slot exception;

    trailerId:= select t.filmId from trailer t, film f where t.title = trailerTitle and f.filmtype = 'trailer';
    start_time:= to_timestamp(st, 'HH:MI:SS AM');

    if(start_time in pre_sched)
      raise invalid_time_slot;

    insert into trailer_schedule (trailerId, screenId, start_time) values(trailerId, screenId, start_time);

    exception
      when no_data_found then
        dbms_output.put_line('Trailer with title ' || trailerTitle || ' exists.');
      
      when invalid_time_slot then
        dbms_output.put_line('Time slot of ' || start_time || ' has is taken.');

      when others then
        dbms_output.put_line('Invalid time stamp.');

  end;

-- define a record type for trailers and ad's --
create or replace type t_record as object (
  tile film.title%type,
  start_time trailer_schedule.start_time%type,
  end_time trailer_schedule.start_time%type,
  room_num movie_schedule.room_num%type
);

-- define table type for pre-schedule function --
create or replace type t_table as table of t_record;

-- Used to get shcedule for the pre-screening --
function get_pre_schedule(screenId in movie_schedule.screenId%type) 
  return t_table as v_ret t_table;

  cursor pre_screening_items is
      (select f.title, f.runtime, ts.start_time from trailer_schedule ts join film f 
      on ts.filmId = f.filmId join movie_schedule ms on ts.screenId = ms.screenId)
      union
      (select ad.title, ad.runtime, ad_sched.start_time 
      from ad_schedule ad_sched 
      join ad on ad.adId = ad_sched.adId 
      join movie_schedule ms on ms.screenId = ad_sched.screenId);
    
  declare
    pre_sched pre_screening_items%rowtype;
      
  begin
    v_ret:= t_table();

    open pre_screening_items;
    fetch pre_screening_items into pre_sched;

    while pre_screening_items%found loop
      v_ret.extend; v_ret() := t_record(pre_sched.title,
      pre_sched.start_time, 
      get_endtime(pre_sched.start_time, pre_sched.runtime),
      pre_sched.room_num
      );
      fetch pre_screening_items into pre_sched;
      end loop;
    close pre_screening_items;

      
        
  end get_pre_schedule;

/
show errors
