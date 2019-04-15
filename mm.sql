create table film(
	filmId integer primary key,
	title varchar2(25), 
	runtime decimal(3,2),
	filmtype char(7),
	genre varchar2(25),
	license_cost decimal (10,2)
);

create table trailer(
	trailerId integer primary key,
	band varchar2(5),
	foreign key(trailerId) references film(filmId)
);

create table movies(
	movieId integer primary key,
	release_date Date not null,
	expiration_date Date not null,
	rating char(5) not null, 
	foreign key (movieId) references film(filmId)
);

create table movie_schedule(
	filmId integer, 
	screenId integer primary key,
	room_num integer,
	start_time timestamp,
	is_showing integer,
	showdate date,
	foreign key (filmId) references film(filmId)
);

create table ad(
	adId integer primary key,
	title varchar2(25),
	runtime integer,
	in_house integer,
	ad_type varchar2(12),
	company varchar2(30),
	profit decimal(3,2)
);

create table ad_schedule(
	adId integer primary key,
	screenId integer,
	start_time timestamp,
	foreign key(adId) references ad(adId),
	foreign key(screenId) references movie_schedule(screenId)
);

-- TODO encrypt passwords when using bcrypt
create table users(
	id 	integer primary key,
	username varchar2(30) not null,
	password varchar2(30) not null,
	first_name varchar2(20),
	last_name varchar2(20),
	role char(2)
);

create table customer_tickets(
	custId integer primary key,
	screenId integer,
	foreign key (custId) references users(id),
	foreign key (screenID) references movie_schedule(screenId)
);