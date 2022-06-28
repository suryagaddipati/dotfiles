# Brett Terpstra 2014
# <http://brettterpstra.com>
#
# tmux wrapper
# 	tm session-name [window-name]
# Names can be partial from the beginning and first match will connect.
# If no match is found a new session will be created.
# If there's a second argument, it will be used to attach directly to a
# window in the session, or to name the first window in a new session.
tm() {
	local attach window
	if [ -n $1 ]; then
		attach=""

		tmux has-session -t $1 > /dev/null
		if [ $? -eq 0 ]; then
			attach=$1
			shift
		else
			for session in `tmux ls|awk -F ":" '{ print $1 }'`;do
				if [[ $session =~ ^$1  ]]; then
					echo "Matched session: $session"
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
						echo "Matched window: $window"
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
				tmux new-session $SHELL  -s $attach -n $1  \; set default-shell $SHELL
			else
				echo "Attempting to create $1"
				tmux new-session $SHELL -s $1   \; set default-shell $SHELL 
			fi
		fi
	else
		tmux new-session $SHELL \; set default-shell $SHELL
	fi
}
