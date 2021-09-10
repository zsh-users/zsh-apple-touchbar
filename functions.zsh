function print_key() {
  if [ -n "$TMUX" ]
  then
    echo -ne "\ePtmux;\e$*\e\\"
  else
    echo -ne $*
  fi
}

function remove_keys() {
  print_key "\033]1337;PopKeyLabels\a"
}

function unbind_keys() {
  for key in "$keys[@]"; do
    bindkey -s "$key" ''
  done
}

function remove_and_unbind_keys() {
  remove_keys
  unbind_keys
}

function set_state() {
  state=$1
}

function create_key() {
  print_key "\033]1337;SetKeyLabel=F${1}=${2}\a"

  if [ "$4" = "-s" ]; then
    bindkey -s $keys[$1] "$3 \n"
  else
    bindkey $keys[$1] $3
  fi
}

keys=('^[OP' '^[OQ' '^[OR' '^[OS' '^[[15~' '^[[17~' '^[[18~' '^[[19~' '^[[20~' '^[[21~' '^[[23~' '^[[24~')
