source ${0:A:h}/functions.zsh

ruby ${0:A:h}/generate.rb

source ${0:A:h}/touchbar-mappings.zsh

autoload -Uz add-zsh-hook

add-zsh-hook precmd precmd_apple_touchbar
