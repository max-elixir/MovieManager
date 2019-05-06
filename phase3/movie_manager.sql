create or replace package body movie_manager as

  function get_endtime(start_time in timestamp, runtime in film.runtime%type)
      return varchar2 is
      hrs number;
      mins number;
      hold timestamp;
      endtime varchar2(10);

      begin
          hrs:=trunc(runtime);
          mins:=(runtime - hrs)*10;
          hold:= to_timestamp(start_time);
          hold:=hold+ ((1/24)*hrs);
          hold:=hold+ ((1/1440)*mins);
          --dbms_output.put_line(start_time||' then ends at the time '||hold);
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
    dbms_output.put_line('Title | Genre | Rating | Start Time | End Time |Room Number');

    while sched%found loop
      dbms_output.put_line(
        sched_rec.title||'|'||sched_rec.genre||'|'||sched_rec.rating||'|'||sched_rec.start_time||'|'||'|'|| sched_rec.room_num);

      fetch sched into sched_rec;
    end loop;
    close sched;

    exception
      when others then
        dbms_output.put_line('Invalid date, please try again.');
  end;

  -- Used to schedule a trailer for a given movie --
  -- trailerTitle is title of trailer to schedual --
  -- screenId is unique movie screening  --
  -- st is start_time of trailer in HH:Mi:SS AM format --
  procedure schedule_trailer (trailerTitle in varchar2, screenId in integer, st in varchar2) is
    cursor pre_sched is 
      select ts.start_time from trailer_schedule ts where ts.screenId = screenId
      union
      select ad_sched.start_time from ad_schedule ad_sched where ad_sched.screenId = screenId;

    cursor trailer is
      select trailer.trailerId from trailer, film where film.title = trailerTitle and film.filmtype = 'trailer';

    cursor movieStartTime is
      select start_time from movie_schedule ms where ms.screenId=screenId;

    startTime timestamp;
    invalid_time_slot exception;
    over_time_slot exception;

    rec1 pre_sched%rowtype;
    rec2 trailer%rowtype;
    rec3 movieStartTime%rowtype;

    begin
      startTime:= to_timestamp(st, 'HH:MI:SS AM');

      open pre_sched;
      fetch pre_sched into rec1;

      while pre_sched%found loop
        if(startTime = rec1.start_time) then
          raise invalid_time_slot;
        end if;
        fetch pre_sched into rec1;
      end loop;
      close pre_sched;

      -- read from trailer and movieStartTime cursors --
      open trailer;
      open movieStartTime;

      fetch trailer into rec2;
      fetch movieStartTime into rec3;

      if(startTime >= rec3.start_time) then
        raise over_time_slot;
      end if;

      -- schedual trailer and print updated preschedual --
      insert into trailer_schedule (trailerId, screenId, start_time) values(rec2.trailerId, screenId, startTime);
      dbms_output.put_line('Success.');

    exception
      when no_data_found then
        dbms_output.put_line('Trailer with title ' || trailerTitle || ' does not exist.');
        
      when invalid_time_slot then
        dbms_output.put_line('Time slot of ' || startTime || ' is taken.');

      when over_time_slot then
        dbms_output.put_line(' ' || startTime || ' is past the movie start time of: ' || to_char(rec3.start_time, 'HH:MI'));

      when others then
        dbms_output.put_line('Invalid start time.');

      close trailer;
      close movieStartTime;
    end;

-- Used to get shcedule for the pre-screening --
-- screenId is id of unique movie screening --
-- a table of type t_record is returned --
  procedure get_pre_schedule(screen_id in movie_schedule.screenId%type) is

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

end;
--                                          End of Jason's code                         --
/
show errors
