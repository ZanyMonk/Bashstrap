#----
#- Bash bootstrap - zM
#----

declare -A COLORS
COLORS=(
[default]=39
[black]=30
[red]=31
[green]=32
[yellow]=33
[blue]=34
[magenta]=35
[cyan]=36
[light_gray]=37
[dark_gray]=90
[light_red]=91
[light_green]=92
[light_yellow]=93
[light_blue]=94
[light_magenta]=95
[light_cyan]=96
[white]=97
)

declare -a ANIM
ANIM=(— \\ \| / — \\ /)

readonly ANIM
readonly CHECK="✔"
readonly CROSS="✗"
readonly ANIM_CHARSET="▗▘▝▖▝▖▙▚▛▜▞▟"

anim_pid=0

#----
#- Colorize
#----

#- say $color $string
function say {
	if [[ $# -eq 2  ]]; then
		echo -e "\e[${COLORS[$1]}m$2\e[39m"
	else
		echo $1
	fi
}

#- success $string
function success {
	say green "[$CHECK] $1"
}

#- error $string
function error {
	say red "[$CROSS] $1"
}


#----
#- Tools
#----

#- in_array $needle $haystack
in_array() {
	declare -a array=("${2}")
	for i in ${array[@]}; do
		[[ $1 == "$i" ]] && return 0
		echo $i
	done
	return 1
}


#----
#- Eye candies
#----

#- animated_loader
animated_loader() {
	(
	i=0
	while true; do
		gen_random_barcode i
		(( i++ ))
		sleep 0.1s
	done;
	) &
	anim_pid=$!
}

#- stop_loader
stop_loader() {
	trap 'exit 0' TERM
	kill -15 $anim_pid
	anim_play=0
}

#- gen_random_barcode $step
gen_random_barcode() {
	str="[${ANIM[$(($1%${#ANIM[@]}))]}] "
	for (( j = 0; j < 20; j++ )); do
		rand=${ANIM_CHARSET:$(($RANDOM%${#ANIM_CHARSET})):1}
		str="$str$rand"
	done
	echo -en "\r$str\r"
}
