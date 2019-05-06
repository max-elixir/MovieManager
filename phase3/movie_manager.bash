#!/bin/bash
sqlplus -S hwt460/01592719 <<ENDOFSQL
start movie_manager_spec;
start movie_manager;
set serveroutput on;
exec movie_manager.get_schedule('26-APR-2019');
exec movie_manager.get_schedule('invalid');
exec movie_manager.show_trailers;
exec movie_manager.show_pre_schedule(5);
exec movie_manager.schedule_trailer('Toy Story 4',5,'1:55 PM');
exec movie_manager.show_pre_schedule(5);
exec movie_manager.show_screenings;
exec movie_manager.show_pre_schedule(1);
exec movie_manager.print_profit('APR 2019');
exec movie_manager.reserve_ticket('user', 'password', 1);


exit;
