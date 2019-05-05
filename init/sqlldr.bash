#!/bin/bash

# load films
sqlldr control=film.ctl log=film.log bad=film.bad

# load movies
sqlldr control=movies.ctl log=movies.log bad=movies.bad

# load movie_schedule
sqlldr control=movie_schedule.ctl log=movie_schedule.log bad=movie_schedule.bad

# load trailer
sqlldr control=trailer.ctl log=trailer.log bad=trailer.bad

# load trailer schedules
sqlldr control=trailer_schedule.ctl log=trailer_schedule.log bad=trailer_schedule.bad

# load ad's
sqlldr control=ad.ctl log=ad.log bad=ad.bad

# load ad_schedule
sqlldr control=ad_schedule.ctl log=ad_schedule.log bad=ad_schedule.bad

# load users
sqlldr control=users.ctl log=users.log bad=users.bad

# load customer_tickets
sqlldr control=customer_tickets.ctl log=customer_tickets.log bad=customer_tickets.bad
