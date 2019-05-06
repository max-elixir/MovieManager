#!/bin/bash
sqlplus -S gan022/01654944 <<ENDOFSQL
start movie_manager_spec;
start movie_manager;
set serveroutput on;
exec movie_manager.get_schedule('26-APR-2019');
exec movie_manager.schedule_trailer('Hellboy',77,'1:55:00 am');
exec movie_manager.show_screenings;
exec movie_manager.get_pre_schedule(1);
exec movie_manager.print_profit('APR 2019');
exec movie_manager.reserve_ticket('user', 'password', 1);


exit;
