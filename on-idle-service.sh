#!/bin/bash

display=:0                                # while locally logged into desktop environment, run `echo $DISPLAY` to find out what this value should be
Xauthority=/run/user/1000/gdm/Xauthority  # while locally logged into desktop environment, run `echo $XAUTHORITY` to find out what this value should be

export DISPLAY=$display           # this is needed for graphical desktop interaction
export XAUTHORITY=$Xauthority     # this is needed for graphical desktop interaction

idleTimeout=5400            # how many idle seconds to wait for shutdown
idleCmd="shutdown -h 0"     # command to run when idleTimeout is reached
checkInterval=10            # how many seconds between checks

isIdle() {
	who | grep -P "\s:\d" | while read activeUser
	do
		user=$(awk '{print $1}' <<< "$activeUser");
		display=$(awk '{print $2}' <<< "$activeUser");
		userIdle=$(DISPLAY=$display sudo -u $user xprintidle)
		idleTime=$[ $userIdle / 1000 ]
		[ $idleTime -lt $idleTimeout ] && return 1 || :
	done
	return $?
}

while ! isIdle
do
	sleep $checkInterval
done
eval "$idleCmd"
exit
