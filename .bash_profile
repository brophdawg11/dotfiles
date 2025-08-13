echo "Running .bash_profile"

# Prerequisites to be set in .bash_profile_local_pre:
# BREW_DIR - base installation dir for homebrew

##### Machine-local pre config #####
if [ -f ~/.bash_profile_local_pre ]; then
    echo "Running .bash_profile_local_pre"
    . ~/.bash_profile_local_pre
else
    echo "No .bash_profile_local_pre file found, exiting!"
    return
fi

cd "${START_DIR}"

##### Global Updates #####
export PATH="${HOME}/bin:$PATH"
export PATH="${BREW_DIR}/bin:$PATH"
export EDITOR="emacs"
export GREP_OPTIONS="--color"
export HOMEBREW_BUNDLE_FILE="~/Brewfile"
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# Homebrew bash completion (includes git)
[ -f "${BREW_DIR}/etc/bash_completion" ] && . "${BREW_DIR}/etc/bash_completion"

##### Aliases #####
alias ls="ls -Fla"
alias rm="rm -i"
alias npx-debug="npx --node-options=\"--inspect-brk\""
alias nodets="node --experimental-strip-types"
alias bp="code ~/.bash_profile"
alias bpl="code ~/.bash_profile_local_pre"


##### Utility Functions #####

# Kill the process on a given port
killport () {
    for proc in $(lsof -w -n -i tcp:$1 | awk 'NR!=1 {print $2}')
    do
        kill -9 $proc && echo "Killed $1"
    done
}

# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
    rm -i "$MARKPATH/$1"
}
#function marks {
#    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
#}
# OSX Version
function marks {
    ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

# Delete the docker qcow2 file to clean up space on OSX
# function docker-qcow2-cleanup {
#   docker ps
#   if [ $? == 0 ]; then
#     echo "Please kill docker first";
#   elif [! -f ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2 ]; then
#     echo "No Docker.qcow2 file found";
#   else
#     df -h
#     echo "Removing Docker.qcow2"
#     ls ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/
#     rm -f ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2
#     df -h
#   fi
# }

##### Bash Prompt #####
Green="\[\033[0;32m\]"        # Green
BYellow="\[\033[1;33m\]"      # Yellow (bold)
IRed="\[\033[0;91m\]"         # Red (high intensity)
PathShort="\w"
Color_Off="\[\033[0m\]"       # Text Reset
export PS1=$BYellow$PathShort$Color_Off'$(git branch &>/dev/null;\
if [ $? -eq 0 ]; then \
  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  if [ "$?" -eq "0" ]; then \
    # @4 - Clean repository - nothing to commit
    echo "'$Green'"$(__git_ps1 " (%s)"); \
  else \
    # @5 - Changes to working tree
    echo "'$IRed'"$(__git_ps1 " {%s}"); \
  fi)'$Color_Off'> "; \
else \
  # @2 - Prompt when not in GIT repo
  echo "'$Color_Off'> "; \
fi)'

# If in VSCode, cd to the project directory
if [ $TERM_PROGRAM == "vscode" ] && [ $OLDPWD != "" ]; then
    echo "cd-ing to the current VSCode project directory"
    cd $OLDPWD
fi

##### Machine-local post config #####
if [ -f ~/.bash_profile_local_post ]; then
    echo "  Running .bash_profile_local_post"
    . ~/.bash_profile_local_post
fi
