create or replace package movie_manager as
  procedure get_schedule(
    today in varchar2 default to_char(SYSDATE,'DD-MON-YYYY'));

  function get_endtime
    (start_time in timestamp, runtime in film.runtime%type)
    --return timestamp;
    return varchar2;
end;
/
show errors
