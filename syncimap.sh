#!/bin/sh
#
# Example for imapsync massive migration on Unix systems.
# 
# Create an folder in the same folder as the script with the name TMP
# Host1 = source, host2=target
#
# Data is supposed to be in file.txt in the following format
# user001_1;password001_1;user001_2;password001_2
# Separator is character semi-colon ; it can be changed by any character changing IFS=';'
# Each data line contains 4 columns, columns are parameters for --user1 --password1 --user2 --password2
#
# Replace "imap.side1.org" and "imap.side2.org" with your own hostname values
# This loop will also create a log file called LOG/log_${u2}_$NOW.txt for each account transfer
# where u2 is just a variable containing the user2 account name, and NOW is the current date_time
# Run the script by starting a terminal, browsing to the folder and start the script with ./syncimap.sh

mkdir -p LOG
{ while IFS=';' read  u1 p1 u2 p2
   do
        { echo "$u1" | egrep "^#" ; } > /dev/null && continue
	NOW=`date +%d-%m-%Y^%H:%M:%S`
          echo syncing "$u1" to user "$u2"
        imapsync --sep1 / --ssl1 --usecache --useuid --tmpdir TMP --addheader --host1 sourcehost(ip/name) --user1 "$u1" --password1 "$p1" \
	--host2 destinationhost(ip/name) --user2 "$u2" --password2 "$p2" \
	> LOG/log_${u2}_$NOW.txt 2>&1
   done
} < file.txt
