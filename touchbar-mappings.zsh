set_state 'first'

function first_view() {
	remove_and_unbind_keys

	set_state 'first'

	create_key 1 '👉 pwd' 'pwd |tr -d "\\n" |pbcopy' '-s'
	create_key 2 'second view' 'second_view'
	create_key 3 'third view' 'third_view'
}

function second_view() {
	remove_and_unbind_keys

	set_state 'second'

	create_key 1 '👈 back' 'first_view'
	create_key 2 'current path' 'pwd' '-s'

	set_state 'first'
}

function third_view() {
	remove_and_unbind_keys

	set_state 'third'

	create_key 1 '👈 back' 'first_view'
	create_key 2 'Hello' 'ls -la' '-s'
}

zle -N first_view
zle -N second_view
zle -N third_view

precmd_apple_touchbar() {
	case $state in
		first) first_view ;;
		second) second_view ;;
		third) third_view ;;
	esac
}