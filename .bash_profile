# Source machine-local configs (pre)
if [ -f ~/.bash_profile_local ]; then
  . ~/.bash_profile_local
fi

cd "${START_DIR}"

export EDITOR=emacs
export GREP_OPTIONS="--color"
export HOMEBREW_BUNDLE_FILE="~/Brewfile"
alias ls="ls -Fla"
alias rm="rm -i"

## Bring in git-prompt and tab completion
. /usr/local/Cellar/git/2.17.0/etc/bash_completion.d/git-prompt.sh
. /usr/local/Cellar/git/2.17.0/etc/bash_completion.d/git-completion.bash

## Homebrew bash completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

## http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
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
function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

# Bash Prompt
Color_Off="\[\033[0m\]"       # Text Reset
Green="\[\033[0;32m\]"        # Green
BYellow="\[\033[1;33m\]"      # Yellow
IRed="\[\033[0;91m\]"         # Red
PathShort="\w"
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

export N_PREFIX="$HOME/lib/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# If in VSCode, cd to the project directory
if [ $TERM_PROGRAM == "vscode" ] && [ $OLDPWD != "" ]; then
    echo "cd-ing to the current VSCode project directory"
    cd $OLDPWD
fi

# Source machine-local configs (post)
if [ -f ~/.bash_profile_local_post ]; then
  . ~/.bash_profile_local_post
fi

