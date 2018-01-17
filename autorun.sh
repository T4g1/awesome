#!/usr/bin/env bash

function run {
    count=1;

    if [ ! -z $2 ] ;
    then
        count=$2
    fi

    result=$(pgrep -c $1);
    echo $result;
    while [ "$result" -lt "$count" ] ;
    do
        $1&
        result=$(pgrep -c $1);
    done
}

run chromium
run subl3
run gpmdp
