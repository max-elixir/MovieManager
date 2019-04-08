create schema moviemanager;

create table film(
	filmId integer primary key,
	title varchar2(25), 
	runtime decimal(3,2),
	
	license_cost decimal (10,2)
);

create table trailer(
	trailerId integer primary key,
	band varchar2(5),
	foreign key(trailerId) references film(filmId)
);

create table movie(
	movieId integer primary key,
	release_date Date not null,
	expiration_date Data not null,
	rating integer, 
	genre varchar2(10)
);

create table ad_schedule(
	adSchedId integer primary key,
	screenId integer primary key,
	start_time decimal(3,2),
	foreign key(adSchedId) references ad(adId),
	foreign key(screenId) references movie_schedule(screenId)
);