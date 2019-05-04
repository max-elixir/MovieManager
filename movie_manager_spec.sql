create or replace package movie_manager as
  procedure get_schedule
    (today in varchar2 default to_char(SYSDATE,'DD-MON-YYYY'));
end;
/
show errors
