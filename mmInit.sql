insert into film values(0, 'Avengers: Endgame', 3.0, 'movie', 'superhero', 300.00);
insert into film values(1, 'Spiderman: Far From Home', 0.05, 'trailer', 'superhero', 50.00);
insert into film values(2, 'Toy Story 4', 0.05, 'trailer', 'Family', 50.00);
insert into film values(3, 'Hellboy (2019)', 2.0, 'movie', 'action', 200.00);
insert into film values(4, 'Little', 1.5, 'movie', 'comedy', 200.00);

insert into trailer values(1, green);
insert into trailer values(2, green);

insert into movie values(0, 26-APR-2019, 26-JUL-2019, 'pg-13');
insert into movie values(3, 12-APR-2019, 12-MAY-2019, 'R');
insert into movie values(4, 12-APR-2019, 12-MAY-2019, 'PG-13');

insert into movie_schedule values(0, 0, 1, 26-APR-2019 10.00, 1, 26-APR-2019);
insert into movie_schedule values(0, 1, 2, 26-APR-2019 10.30, 1, 26-APR-2019);
insert into movie_schedule values(0, 2, 3, 26-APR-2019 12.00, 1, 26-APR-2019);
insert into movie_schedule values(0, 3, 1, 26-APR-2019 2.00, 1, 26-APR-2019);
insert into movie_schedule values(1, 4, 1, 26-APR-2019 9.57, 1, 26-APR-2019);
insert into movie_schedule values(1, 5, 2, 26-APR-2019 10.27, 1, 26-APR-2019);
insert into movie_schedule values(1, 6, 3, 26-APR-2019 11.57, 1, 26-APR-2019);
insert into movie_schedule values(3, 7, 2, 26-APR-2019 10.45, 0, 26-APR-2019);

insert into ad values(0, 'Coca-Cola: summer vacation', 0.01, 0, 'commercial', 'coca-cola', 100.50);
insert into ad values(1, 'lets all go to the lobby', 0.01, 1, 'in-house', 'theater', 0.0);
insert into ad values(2, 'SA Film Festival', 0.01, 0, 'commercial', 'City of San Antonio', 20.00);

insert into ad_schedule values(0, 8, 19-SEP-2019 12.00);
insert into ad_schedule values(1, 9, 26-OCT-2019 12.00);
insert into ad_schedule values(1, 10, 26-NOV-2019 12.00);

insert into users values(0, 'max_elixir', 'blue12345', 'Max', 'Guzman', 'SA');
insert into users values(1, 'buitrago', 'groupLeader1', 'Isaac', 'Buitrago', 'SA');
insert into users values(2, 'jason-kha', 'yoshi', 'Jason', 'Kha', 'SA');
insert into users values(3, 'bsmith', 'bigboss', 'Brad', 'Smith', 'O');
insert into users values(4, 'hmendez', 'yugioh', 'Henry', 'Mendez', 'M');
insert into users values(5, 'asolis', 'coolmom', 'Amy', 'Solis', 'M');
insert into users values(6, 'rotiz', 'bigknife', 'Roman', 'Ortiz', 'M');
insert into users values(7, 'pochoa', 'yeahthatsfine', 'Paul', 'Ochoa', 'M');
insert into users values(8, 'user', 'password', 'john', 'doe', 'C');
insert into users values(9, 'username', 'password', 'jane', 'doe', 'C');
insert into users values(10, 'Markiplier', 'mustache', 'Mark', 'Fishbach', 'C');
insert into users values(11, 'rslavin', 'systems', 'Rocky', 'Slavin', 'C');
insert into users values(12, 'lclark', 'readthenotes', 'Larry', 'Clark', 'C');

insert into customer_tickets values(0, 0);
insert into customer_tickets values(1, 0);
insert into customer_tickets values(2, 0);
insert into customer_tickets values(3, 1);
insert into customer_tickets values(4, 1);
insert into customer_tickets values(5, 1);
insert into customer_tickets values(6, 3);
insert into customer_tickets values(7, 3);
insert into customer_tickets values(8, 3);
insert into customer_tickets values(9, 3);
insert into customer_tickets values(10, 2);
