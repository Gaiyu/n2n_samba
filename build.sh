#!/bin/bash
red_log()
{
	echo -e "\033[1;31m${1}\033[m"
}

green_log()
{
	echo -e "\033[1;32m${1}\033[m"
}

yellow_log()
{
	echo -e "\033[1;33m${1}\033[m"
}

logo()
{
	clear
	yellow_log "--------------------------"
	green_log "Please choose a platform :"
	yellow_log "--------------------------"
}

declare -a TAGS
TAG=''
MSG=''

menu()
{
	I=0
	logo
	for LINE in $(ls Dockerfile.*)
	do
		let I++
		TAGS[I]=$(echo $LINE | awk -F '.' '{print $NF}')
		yellow_log "[$I].${TAGS[I]}"
	done
	yellow_log "--------------------------"
	[ ! -z "$1" ] && red_log "Unsupported option : $1"
	red_log "Select a number [1-$I], or press '[Q/q] to exit..."
}

while [ -z "$TAG" ]
do
	menu "$MSG"
	read MSG
	case "$MSG" in
		'q' | 'Q')
			green_log 'bye!'
			exit 0
			;;
		[1-9][0-9] | [1-9])
			[ $MSG -le ${#TAGS[@]} ] && [ $MSG -gt 0 ] && TAG="${TAGS[MSG]}"
			;;
	esac
done

clear
yellow_log "--------------------------"
green_log "Building : n2n_samba:${TAG}"
yellow_log "--------------------------"
cp Dockerfile.${TAG} Dockerfile
docker build -t n2n_samba:${TAG} .
rm -f Dockerfile
