create or replace package body movie_manager as

  function get_endtime(start_time in timestamp, runtime in film.runtime%type)
      return varchar2 as endtime varchar2(10);
      hrs number;
      mins number;
      hold timestamp;

      begin
          hrs:=trunc(runtime);
          mins:=(runtime - hrs)*10;
          hold:= to_timestamp(start_time);
          hold:=hold+ ((1/24)*hrs);
          hold:=hold+ ((1/1440)*mins);
          endtime:= to_char(hold, 'hh24:mi');
          return endtime;
      end;

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
    dbms_output.put_line('Title | Genre | Rating | Start Time | End Time | Room Number');

    while sched%found loop
      dbms_output.put_line(
        sched_rec.title||'|'||sched_rec.genre||'|'||sched_rec.rating||'|'||sched_rec.start_time||'|'||get_endtime(sched_rec.start_time, sched_rec.runtime)||' | '||sched_rec.room_num);

      fetch sched into sched_rec;
    end loop;
    close sched;

    exception
      when value_error then
        dbms_output.put_line('Invalid date, please try again.');

      when others then
        dbms_output.put_line('Something happened');

  end;

  -- Used to schedule a trailer for a given movie --
  -- trailerTitle is title of trailer to schedual --
  -- screenId is unique movie screening  --
  -- st is start_time of trailer in HH:Mi:SS AM format --
  procedure schedule_trailer (trailerTitle in varchar2, screenId in integer, st in varchar2) is
    cursor trailer is
      select t.trailerId from trailer t join film f on t.trailerId=f.filmId where f.title = trailerTitle;

    startTime timestamp;

    rec2 trailer%rowtype;

    begin

      -- open all cursors --
      open trailer;

      -- convert user start time into timestamp --
      startTime:= trunc(to_timestamp(st, 'HH:MI AM'));

      dbms_output.put_line(''||startTime);

      fetch trailer into rec2;

      -- schedual trailer and print updated preschedual --
      insert into trailer_schedule (trailerId, screenId, start_time) values(rec2.trailerId, screenId, startTime);
      dbms_output.put_line('"'|| trailerTitle ||'"'|| ' succesfully scheduled !');
      show_pre_schedule(screenId);

      close trailer;

    end;

-- Used to get shcedule for the pre-screening --
-- screenId is id of unique movie screening --
-- a table of type t_record is returned --
  procedure show_pre_schedule(screen_id in movie_schedule.screenId%type) is

    cursor pre_screening_items is
      select f.title, f.runtime, ts.start_time, ms.room_num from trailer_schedule ts 
      join film f on ts.trailerId = f.filmId join movie_schedule ms on ts.screenId = screen_id
      union
      select ad.title, ad.runtime, ad_sched.start_time, ms.room_num
      from ad_schedule ad_sched 
      join ad on ad.adId = ad_sched.adId 
      join movie_schedule ms on ms.screenId = screen_id;
      
      pre_sched pre_screening_items%rowtype;
        
    begin

      open pre_screening_items;
      fetch pre_screening_items into pre_sched;

      dbms_output.put_line('Title | Start Time | Endtime | Room Number');

      while pre_screening_items%found loop

        dbms_output.put_line(''||pre_sched.title||' | '|| to_char(pre_sched.start_time, 'hh:mi AM')||' | '||
        get_endtime(pre_sched.start_time, pre_sched.runtime)||' | '||pre_sched.room_num);

        fetch pre_screening_items into pre_sched;
      end loop;

      close pre_screening_items;
    end;

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

    -- Prints all screenings with screen id, movie title, and start time --
    procedure show_screenings is

      cursor screenings is
        select ms.screenId, f.title, ms.start_time from movie_schedule ms join film f on ms.filmId=f.filmId;

      sc screenings%rowtype;

      begin

        dbms_output.put_line('Screen Id | Title | Start Time');

        open screenings;
        fetch screenings into sc;

        while screenings%found loop
          dbms_output.put_line(''||' | '||sc.screenId||' | '|| sc.title ||' | '|| to_char(sc.start_time, 'hh:mi AM'));
          fetch screenings into sc;
        end loop;

        close screenings;

      end;

    procedure show_trailers is
      cursor trailers is
        select f.title from film f where f.filmtype='trailer';

      my_rec trailers%rowtype;

      begin
        open trailers;

        fetch trailers into my_rec;

        dbms_output.put_line('__Title__');

        while trailers%found loop
          dbms_output.put_line(''||' | '||my_rec.title||' | ');

          fetch trailers into my_rec;
        end loop;

        close trailers;
      end;

    procedure show_ads is
      cursor ads is
          select ad.title from ad;

        my_rec ads%rowtype;
        begin
          open ads;

          fetch ads into my_rec;

          dbms_output.put_line('__Title__');

          while ads%found loop
            dbms_output.put_line(''||' | '||my_rec.title||' | ');

            fetch ads into my_rec;
          end loop;

          close ads;
        end;

end;
--                                          End of Jason's code                         --
/
show errors
