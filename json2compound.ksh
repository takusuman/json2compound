integer c dflag qflag

# Declaration flag
# dflag
# Quote flag
# qflag

#for ((;;)); do
#	if read line; then
#		fbuf+="$line "
#	else
#		break
#	fi
#done
fbuf="$(cat ${1:--})"

for (( c=0; c < ${#fbuf}; c++ )); do 
	# Get current char from string.
	cchr="${fbuf:$c:1}"
	if [[ "$cchr" == '"' ]]; then
		((qflag= !qflag))
		if (( dflag )); then
			cchr=" "
		fi
	fi
	if (( ! qflag )); then
	if [[ "$cchr" == '{' || "$cchr" == '[' ]]; then
	       cchr='('
	elif [[ "$cchr" == '}' || "$cchr" == ']' ]]; then
		cchr=')'
	elif [[ "$cchr" == ':' ]]; then
		((dflag= !dflag))
		cchr='='
	elif [[ "$cchr" == ',' ]]; then
		cchr=" "
	elif [[ "$cchr" == [[:space:]] ]]; then
		((dflag= !dflag))
		continue
	fi
	fi
	printf '%c' "$cchr"
done
