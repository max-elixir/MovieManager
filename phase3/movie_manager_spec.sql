create or replace package movie_manager as
  procedure get_schedule(today in varchar2 default to_char(SYSDATE,'DD-MON-YYYY'));

  procedure schedule_trailer(trailerTitle in varchar2, screenId in integer, st in varchar2);

  function get_profit(monthYear char)
    return Ad.profit%type;

  procedure print_profit(monthYear char);

  procedure reserve_ticket(username users.username%type, password users.password%type, screenId movie_schedule.screenId%type);

  function get_endtime(start_time in timestamp, runtime in film.runtime%type)
      return varchar2 as endtime varchar2(30):=to_char(start_time);

end;
/
show errors
