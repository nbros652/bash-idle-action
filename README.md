# bash-idle-action
Run an action when all logged on users are idle for a predetermined number of seconds.

To get this working:
 - Install xprintidle: `sudo apt install -y xprintidle`
 - copy the **on-idle-service.sh** script to **/root/scripts/**
 - open and edit that same script and modify the three variables at the top to your purposes
 - copy the **on-idle.service** file to the **/etc/systemd/system/** folder
 - run:
   - `sudo systemctl enable on-idle`
   - `sudo systemctl start on-idle`
   
   
Assuming you edited the **on-idle-service.sh** file and added the appropriate command and set the idle time correctly, the system you have just installed to should run the command you specified when *all* logged in desktop users have been idle the number of seconds specified.
