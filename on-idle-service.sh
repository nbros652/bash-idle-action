#!/bin/bash


idleCmd="touch /tmp/idle"   # command to run when idleTimeout is reached
idleTimeout=600             # how many idle seconds to wait before running idleCmd
checkInterval=10            # how many seconds between checks

isIdle() {
    while read activeUser
    do
        user=$(awk '{print $1}' <<< "$activeUser");
        id=$(grep -P "^ccc:" /etc/passwd | cut -f3 -d:)
        display=$(awk '{print $2}' <<< "$activeUser");
        export DISPLAY=$display
        export XAUTHORITY=/run/user/$id/gdm/Xauthority
        userIdle=$(su $user -c xprintidle)
        idleTime=$[ $userIdle / 1000 ]
        if [ $idleTime -lt $idleTimeout ]; then
            return 1
        else 
            return 0
        fi
    done <<< "$(who | grep -P "\s:\d")"
# 	return $?
}

while :
do
    if ! isIdle; then
        unset idle
    fi
    
    if [ ! -z "$idle" ] || ! isIdle; then
        sleep $checkInterval
        continue
    fi
    idle=1
    sleep $checkInterval
    eval "$idleCmd"
done
