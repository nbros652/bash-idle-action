#!/bin/bash


idleCmd="touch /tmp/idle"   # command to run when idleTimeout is reached
idleTimeout=600             # how many idle seconds to wait before running idleCmd
checkInterval=10            # how many seconds between checks

isIdle() {
    while read activeUser
    do
        # get some session info
        user=$(awk '{print $1}' <<< "$activeUser");
        id=$(grep -P "^ccc:" /etc/passwd | cut -f3 -d:)
        display=$(awk '{print $2}' <<< "$activeUser");
        
        # export some environment vars specific to the active session
        export DISPLAY=$display
        export XAUTHORITY=/run/user/$id/gdm/Xauthority
        
        # calculate session idle time
        userIdle=$(su $user -c xprintidle)
        idleTime=$[ $userIdle / 1000 ]
        
        if [ $idleTime -lt $idleTimeout ]; then
            # return "false" if the idle timeout has not been reached
            return 1
        else 
            # return true if the idle timeout has been reached
            return 0
        fi
    done <<< "$(who | grep -P "\s:\d")"
# 	return $?
}

# start an infinite loop for checking idle timeout
while :
do
    # check if we are not idle or the idle command has already run
    if [ ! -z "$idle" ] || ! isIdle; then
        isIdle || unset idle    # if we were idle, but no longer are, note the change
        sleep $checkInterval
        continue
    fi
    
    # We're idle, and the idleCmd has not been run; run it!
    idle=1
    eval "$idleCmd"
    sleep $checkInterval
done
