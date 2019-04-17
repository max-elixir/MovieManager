create table film(
        filmId integer primary key,
        title varchar2(25) not null,
        runtime decimal(3,2) not null,
        filmtype char(7) not null,
        genre varchar2(25),
        license_cost decimal (6,2) not null
);

create table trailer(
        trailerId integer primary key,
        band varchar2(6) not null,
        foreign key(trailerId) references film(filmId)
        on delete cascade        
);

create table movies(
        movieId integer primary key,
        release_date Date not null,
        expiration_date Date not null,
        rating char(6) not null,
        foreign key (movieId) references film(filmId)
        on delete cascade
);

create table movie_schedule(
        filmId integer not null,
        screenId integer primary key,
        room_num integer not null,
        is_showing integer not null,
        start_time timestamp not null,
        foreign key (filmId) references film(filmId) on delete cascade
);

create table trailer_schedule(
        trailerId integer not null,
        screenId integer not null,
        start_time timestamp not null,
        foreign key (trailerId) references film(filmId),
        foreign key (screenId) references movie_schedule(screenId),
        constraint t_pk primary key(trailerId, screenId)
);

create table ad(
        adId integer primary key,
        title varchar2(25) not null,
        runtime integer not null,
        in_house tinyint not null,
		profit decimal(6,2) not null
        company varchar2(30)
);

create table ad_schedule(
        adId integer not null,
        screenId integer primary key,
        start_time timestamp,
        foreign key(adId) references ad(adId) on delete cascade,
        foreign key(screenId) references movie_schedule(screenId) on delete cascade
);

-- TODO encrypt passwords when using bcrypt --
create table users(
        id integer primary key,
        username varchar2(25) not null,
        password varchar2(30) not null,
        first_name varchar2(20),
        last_name varchar2(20),
        role char(2)
);

create table customer_tickets(
        custId integer primary key,
        screenId integer not null,
        foreign key (custId) references users(id) on delete cascade,
        foreign key (screenID) references movie_schedule(screenId) on delete cascade
);
