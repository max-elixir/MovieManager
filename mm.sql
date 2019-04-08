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