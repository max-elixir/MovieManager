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

--                                Jason's code                                      --
    -- get_profit
    function get_profit(monthYear char)
    return Ad.profit%type is
        -- initialize variables
        profitTotal Ad.profit%type := 0;
        -- ad and ad_schedule query
        cursor profit_c is
        select profit from ad a join ad_schedule s on a.adid = s.adid where monthYear in (select to_char(s.start_time, 'MON YYYY') from ad_schedule);
        profit_rec profit_c%rowtype;
    begin
        -- open cursor and loop through
        open profit_c;
        fetch profit_c into profit_rec;
        while profit_c%found loop
            -- add each profit from cursor to profitTotal
            profitTotal := profitTotal + profit_rec.profit;
            fetch profit_c into profit_rec;
        end loop;
        close profit_c;

        -- return
        return profitTotal;

    -- exception handling
    exception
        when others then
            dbms_output.put_line('Error: Invalid month or year: ' || monthYear);
    end;

    -- print_profit
    procedure print_profit(monthYear char) is
    begin
        -- output
        dbms_output.put_line('Total Ad profit for ' || monthYear || ' is: $' || get_profit(monthYear));
    end;

    -- reserve_ticket
    procedure reserve_ticket(username users.username%type, password users.password%type, screenId movie_schedule.screenId%type) is
        -- initialize values
        userNotExist exception;
        passNotValid exception;
        screenIdNotExist exception;
        userFound number;
        passwordFound number;
        screenFound number;
        userId users.id%type;
        -- users query
        cursor users_c is
        select * from users;
        users_rec users_c%rowtype;
        -- movie_schedule query
        cursor ticket_c is
        select * from movie_schedule;
        ticket_rec ticket_c%rowtype;
    begin
        -- if found
        userFound := 0;
        passwordFound := 0;
        screenFound := 0;
        userId := -1;

        -- loop through all users queries
        open users_c;
        fetch users_c into users_rec;
        while users_c%found loop
            -- if correct username
            if(users_rec.username = username) then
                userFound := 1;
                userId := users_rec.id;
                -- if correct password
                if(users_rec.password = password) then
                    passwordFound := 1;
                end if;
            end if;
            fetch users_c into users_rec;
        end loop;
        close users_c;

        -- loop through all customer_ticket queries
        open ticket_c;
        fetch ticket_c into ticket_rec;
        while ticket_c%found loop
            -- if screening is valid
            if(ticket_rec.screenId = screenId) then
                screenFound := 1;
            end if;
            fetch ticket_c into ticket_rec;
        end loop;
        close ticket_c;

        -- exceptions
            -- username does not exist
            if(userFound = 0) then
               raise userNotExist;
            end if;

            -- invalid password
            if(passwordFound = 0) then
                raise passNotValid;
            end if;

            -- screenId does not exist
            if(screenFound = 0) then
                raise screenIdNotExist;
            end if;

        -- insert into customer_ticket table
        insert into customer_tickets
        (purchaseId, custId, screenId, dateofpurchase)
        values
        ((select max(purchaseId) + 1 from customer_tickets), userId, screenId, (select current_date from dual));

        -- output
        dbms_output.put_line('Successfully reserved ticket on ' || current_date);

    -- exception handling
    exception
        when userNotExist then
            dbms_output.put_line('Error: Username does not exist: ' || username);
        when passNotValid then
            dbms_output.put_line('Error: Password is invalid');
        when screenIdNotExist then
            dbms_output.put_line('Error: ScreenId does not exist: ' || screenId);
    end;
--                                          End of Jason's code                         --

end;

/
show errors
