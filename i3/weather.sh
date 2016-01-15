#!/bin/bash
# ********************************************************
# file: weather.sh
# date: 2008-11-19 23:04
# author: Marko Schulz - <info@tuxnet24.de>
# description: Script to get the current weather data.
# ********************************************************
#
# EXAMPLE:
# tux@earth:~$ ./weather.sh GMXX0007
#
# Define the page where you get the weather informations.
page="http://weather.tuxnet24.de/?id="
#
# Set the user-agent (curl + lynx are supportet)
useragent="curl"
#
# ********************************************************
# This function connect to the weater page and convert the
# output as keys/value pairs.

function rc_weather () {

local agent=$1
local url=$2
local opt="-source"
[ "${agent}" = "curl" ] && opt="-s"

for line in $( ${agent} ${opt} $url | egrep -v '^$' | sed 's/[[:space:]]/@/g' ) ; do
	local data=$( echo $line | sed 's/@/ /g' )
	keys=$( echo $data | cut -d= -f1 | sed 's/[[:space:]]$//g' )
	value=$( echo $data | cut -d= -f2 | sed 's/^[[:space:]]//g' )
	eval $keys="\$value"
done

}

# ********************************************************
# program action...

# Get the location code from command line.
location=$1

# Exit the program with 1 if no location code was defined.
[ -z "$location" ] && exit 1

# Exit the program with 2 if not the rigth user-agent was defined.
[ "${useragent}" != "curl" -a "${useragent}" != "lynx" ] && exit 2

# Get the weather from http://weather.tuxnet24.de/.
rc_weather "${useragent}" "${page}${location}"

# Set up the conky [text_buffer_size] to 256 or higher.
# Ubuntu do not display the ° sign correctly even the LANG settings are set to UTF-8.
# I have no solution for this problem.

# echo -e "Aktuelles Wetter - ${city}"
echo -e "${current_text}, ${current_temp}"
echo -e "Sicht: ${visibility}"
echo -e "Luftfeuchtigkeit: ${humidity}"
echo -e "Wind: ${speed}, ${direction}\n"
echo -e "Vorhersage: ${tomorrow_day}, ${tomorrow_date}"
echo -e "${tomorrow_text}, min. ${tomorrow_temp_low}, max. ${tomorrow_temp_high}"
exit 0

# ********************************************************
# EOF
