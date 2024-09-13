function json2compound {
	export libname="$0"

	# Stringfy file
	for (( ; ; )); do
		if read -r line; then
			fbuf+="$line "
		else
			break
		fi
	done < <(cat "${1:--}")

	dotjson2compound "$fbuf"
	unset fbuf
}

function dotjson2compound {
	fbuf="$1"
	# String length
	strl=${#fbuf}

	for ((c=0; c < strl; c++)); do
		# Get current char from string.
		cchr="${fbuf:c:1}"
		case "$cchr" in
			'[') arrayparse "${fbuf:c:strl}"
				c+=$arraysiz ;;
			'{')	# Object, treating only as another scope
				# of the compound variable
				newchar='(' ;;
			'}')	newchar=')' ;;
			'"')
				((c_chus_one= $c + 1))
				((quote_end=$(countto '"' \
					"${fbuf:$c_chus_one:$strl}") + c))
				fHitQuote=true
				if (( $c == $quote_end )); then
					fHitQuote=false
					unset quote_end
				fi
				newchar="'" ;;
			':') newchar='=' ;;
			',') if ! $fHitQuote; then
				newchar=' '
			else
				newchar="$cchr"
			fi ;;
			*) newchar="$cchr" ;;
		esac

		printf '%c' "$newchar" 
	done

	return 0
}

function arrayparse {
	array="$1"

	arraylen=(start=$(($(countto '[' "$array") + 1))
	end=$(($(countto ']' "$array") - 1)))

	nelements=0	
	for ((i=${arraylen.start}; i <= ${arraylen.end}; i++)); do
		# Current character
		cchr=${array:i:1}

		case "$cchr" in
		',')
			((nelements= $nelements + 1))
			continue
			;;
		*) elements[$nelements]+="$cchr" ;;
		esac
	done

	printf '%c' '('
	for ((j = 0; j <= nelements; j++)); do
		printf ' %s ' \
			"$(dotjson2compound "${elements[$j]}")"
	done
	printf '%c' ')'

	unset id elements nelements
	export arraysiz=${#array}
}

# Count character position from left to right
# countto char
function countto {
	chr="$1"
	str="$2"
	strl=${#str}

	for ((i = 0; i < strl; i++)); do
		cchr="${str:i:1}"
		case $cchr in
		'[') i+=$(countto "${str:i:strl}" ']') ;;
		'{') i+=$(countto "${str:i:strl}" '}') ;;
		'\')
			i+=1
			continue
			;;
		esac
		if [[ "$cchr" == "$chr" ]]; then
			printf '%d' $i
			break
		fi
	done
}

function panic {
	msgbuf="$(printf "$@")"

	printf 1>&2 '%s: panic: %s\n' \
		"$libname" "$msgbuf"
	return 1
}
