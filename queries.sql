
-- 1. Retrieve the movie titles that are rated PG-13 or R --
select title from film f join movies m 
on f.filmId = m.movieId where m.rating = 'PG-13' or m.rating = 'R';

-- 2. Retrieve movie titles with a release date of 2 months --
select title from film f join movies m 
on f.filmId = m.movieId where m.release_date >=
(select add_months(sysdate,-2) from dual)
and m.release_date <= (select current_date from dual);

-- 3. Schedule the trailer for spider-man to play during the pre-screening of Hellboy --
insert into trailer_schedule (trailerId, screenId, start_time) values(
    (select filmId from film where title = 'Spiderman: Far From Home' and filmtype = 'trailer'),
    (select screenId from movie_schedule ms join film f on f.filmId = ms.filmId
     where f.title = 'Hellboy (2019)' and f.filmtype = 'movie'),
    (select current_timestamp from dual) - 1);

-- 4. Calculate total cost of displaying superheros movies --
select totalCost from (select sum(license_cost) totalCost from film f where genre = 'superhero' group by genre);

-- 5. Retrieve Rated R movie titles released before April of 2019 --
select title from film f join movies m on f.filmId = m.movieId
where m.release_date < '01-APR-19' and m.rating = 'R';

-- 6. Retrieve all movies playing in room 3 today --
select f.title from film f join movies m on f.filmId = m.movieId 
join movie_schedule ms on m.movieId = ms.filmId 
where ms.room_num = 3 and TRUNC(ms.start_time) = TO_DATE('18-APR-2019', 'DD-MON-YY');

-- 7. Delete movies past the expiration date --
delete from film f where f.filmId in
(select m.movieId from movies m where TRUNC(m.expiration_date) < (select current_date from dual));

-- 8. Retrieve the id's of trailers and ads playing in room 2 --
select ts.trailerId, ts.screenId from trailer_schedule ts
join movie_schedule ms on ms.screenId=ts.screenId where ms.room_num=2
union
select ads.adId, ads.screenId from ad_schedule ads
join movie_schedule ms1 on ms1.screenId=ads.screenId where ms1.room_num=2;

-- 9. Retrieve customer names that have visted at least one screening in the last month --
select u.first_name, u.last_name from users u join customer_tickets ct on u.id=ct.custId 
where u.id in (select custId from customer_tickets ct1 where ct1.dateOfPurchase >= add_months(sysdate,-1) 
and ct1.dateOfPurchase <= (select current_date from dual));

-- 10. Select the most profitable company ad--
select company from ad group by company having sum(profit) = (select max(sum(profit)) from ad group by company);
