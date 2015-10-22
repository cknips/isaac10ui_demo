#!/usr/bin/env bash

# create ssh-config file
ssh_config="$PWD/.vagrant/ssh-config"
vagrant ssh-config > "$ssh_config"

# create unison profile
profile="
root = .
root = ssh://default//vagrant/
ignore = Name .vagrant
ignore = Name .git
ignore = Name tmp
ignore = Name log

prefer = .
repeat = 2
terse = true
dontchmod = true
perms = 0
watch = false
sshargs = -F $ssh_config
"

[ -d $HOME/.unison ] || mkdir $HOME/.unison
echo "$profile" > $HOME/.unison/isaac10ui_demo.prf
