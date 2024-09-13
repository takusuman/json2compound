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
}

function dotjson2compound {
#	set -x
	set -e
	fbuf="$1"
	# String length
	strl=${#fbuf}

	# Initialize declaration flag as false
	fDeclaration=false
	fIdentifierWithSpaces=false
	fHitQuote=false
	# Quote flag
	# qflag
	for ((c=0; c < strl; c++)); do
		# Get current char from string.
		cchr="${fbuf:c:1}"
		
		# Check if the file starts as an object or array:
		case $c in
		0 | $strl)
			case "$cchr" in
			'{' | '}' | '[' | ']')
				case "$cchr" in
				'[')
					arrayend=$(countto "$fbuf" ']')
					arrayparse '' "${fbuf:$c:$arrayend}"
					cchr=''
					;;
				']') cchr='' ;; # Fallthrough
				'{') cchr='(' ;;
				'}') cchr')' ;;
				esac
				;;
#			*) panic 'Expected '\''{}'\'' or '\''[]'\'' characters at the %d position, found %c.' $c "$cchr";;
			esac
			;;
		*) ;;
		esac

		case "$cchr" in
		"'") panic 'Unexpected token "'\''": the JSON standard only accepts double quotes.' ;;
		'"') if $fDeclaration; then
			fHitQuote="true"
			cchr="'"
		
		else
			fIdentifierWithSpaces='true'
			cchr=""
		fi ;;
		':')
			fIdentifierWithSpaces=false
			fDeclaration=true
			cchr='=' ;;
		[[:space:]]) if ! $fDeclaration && $fIdentifierWithSpaces; then
			cchr='_'
		elif ! $fHitQuote; then
			cchr=''
		fi ;;
		'[')
			arrayend=$(countto "$fbuf" ']')
			arrayparse "$id" "${fbuf:c:arrayend}"
			;;
		',')
			fHitQuote=false
			fDeclaration=false
			cchr=" " ;;
		*) if ! $fDeclaration; then
			id+="$cchr"
		fi ;;
		esac

		printf '%c' "$cchr"
	done

	unset fbuf dflag qflag
	return 0
}

function arrayparse {
#	set -x
	id="$1"
	array="$2"

	arraylen=(start=$(($(countto '[' "$array") + 1))
	end=$(($(countto ']' "$array") - 1)))

	nelements=0
	for ((i=${arraylen.start}; i < ${arraylen.end}; i++)); do
		# Current character
		cchr=${array:i:1}

		case "$cchr" in
		',')
			nelements+=1
			continue
			;;
		*) elements[$nelements]+="$cchr" ;;
		esac
	done

	case "x$id" in
	x)
		printf '%c' '('
		for ((j = 0; j <= nelements; j++)); do
			printf ' %s ' \
				"$(dotjson2compound "${elements[$j]}")"
		done
		printf '%c' ')'
		;;
	*) for ((j = 0; j <= nelements; j++)); do
		printf '%s+=( %s ) ' \
			$id "$(dotjson2compound "${elements[$j]}")"
	done ;;
	esac

	unset id elements nelements
}

# Count character position from left to right
# countto char
function countto {
	chr="$1"
	str="$2"
	strl=${#str}

	for ((i = 0; i < strl; i++)); do
		case $chr in
		'\')
			i+=1
			continue
			;;
		esac
		if [[ ${str:i:1} == "$chr" ]]; then
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
