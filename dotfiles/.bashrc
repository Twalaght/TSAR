#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Colour aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Set some ls aliases
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -la'

# Other aliases
alias cp='cp -i'    # Confirm before overwriting
alias mv='mv -i'    # Confirm before overwriting
alias df='df -h'    # Readable sizes

# Export the PS1 prompt
PS1='[\u@\h \W]\$ '

# Enable persistence for pywal colour schemes
# Import colour scheme from wal asynchronously
# &   # Run the process in the background
# ( ) # Hide the shell job control messages
(cat ~/.cache/wal/sequences &)