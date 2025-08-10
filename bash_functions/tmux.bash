tm() {
	local attach window
	if [ -n $1 ]; then
		attach=""

		if tmux has-session -t $1 2>/dev/null; then
			attach=$1
			shift
		else
			for session in `tmux ls 2>/dev/null|awk -F ":" '{ print $1 }'`;do
				if [[ $session =~ ^$1 ]]; then
					attach=$session
					shift
					break
				fi
			done
		fi

		if [[ $attach != "" ]]; then
			if [ $# -eq 1 ]; then
				for win in `tmux list-windows -t $attach|sed -E 's/^[0-9]+: //'|sed -E 's/[*-].*//'`;do
					if [[ $win =~ ^$1 ]]; then
						window=$win
						break
					fi
				done
				tmux attach -t $attach:$window
			else
				tmux attach -t $attach
			fi
		else
			if [ $# -gt 1 ]; then
				attach=$1
				shift
				tmux new -s $attach -n $1
			else
				tmux new -s $1
			fi
		fi
	else
		tmux new
	fi
}
