#!/bin/bash

if [ $# -ne 1 ]; then
        echo "Invalid amount of arguments"
        exit
fi

sqlldr control=$1.ctl log=$1.log bad=$1.bad

cat $1.log
