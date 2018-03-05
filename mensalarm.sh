#!/bin/bash

dependenciesMet=$true

if command -v convert >/dev/null 2>&1 ; then
    echo "imagemagick found"
else
    dependenciesMet=$false
    echo "imagemagick not found!"
fi

if command -v i3lock >/dev/null 2>&1 ; then
    echo "i3lock found"
else
    dependenciesMet=$false
    echo "i3lock not found!"
fi

if ($dependenciesMet); then
	echo "Enter todays mensing time (HH:MM:SS format)":
	read var_time

	menstime=$(date -d "$var_time" +%s)
	MTPlsTen=($menstime+10)
	now=$(date -d $(date +%T) +%s)

	IMAGE=/tmp/mensLock.png

	SIZE=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')

	if [ $menstime \< $now ];
		then
		echo "I'm afraid, you already missed mensing time :("
	else
		while ($true)
		do
		now=$(date -d $(date +%T) +%s)	
		if [[ $now -ge $menstime ]];
		then
			convert -background white -size $SIZE \
			    -gravity Center \
			    -weight 700 -pointsize 200 \
			    caption:"Time to go mensing, my friend!" \
			    $IMAGE
			i3lock -i $IMAGE	
			rm $IMAGE
			break
		fi
		sleep 5
		done
	fi
else
	echo "Please install the missing dependencies"
fi	
