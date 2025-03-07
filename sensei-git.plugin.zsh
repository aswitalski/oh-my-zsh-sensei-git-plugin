# Query/use custom command for `git`.
zstyle -s ":vcs_info:git:*:-all-" "command" _omz_git_git_cmd
: ${_omz_git_git_cmd:=git}

#
# Functions
#

# The current branch name
# Usage example: git pull origin $(current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function current_branch() {
  local ref
  ref=$($_omz_git_git_cmd symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$($_omz_git_git_cmd rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}
# The list of remotes
function current_repository() {
  if ! $_omz_git_git_cmd rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi
  echo $($_omz_git_git_cmd remote -v | cut -d':' -f 2)
}
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

function last_commit() {
  echo $(git log -1 --pretty=format:"%H")
}

# Git log find by commit message
function glf() { git log --all --grep="$1"; }

function ggjs() {
  echo "git grep -n $1 -- '*.js'" | zsh
}

function ggcss() {
  echo "git grep -n $1 -- '*.css'" | zsh
}

function gggjs() {
  echo "git grep -C2 -n --heading --show-function $1 -- '*.js'" | zsh
}

function gggcss() {
  echo "git grep -C2 -n --heading --show-function $1 -- '*.css'" | zsh
}

function gggtsx() {
  echo "git grep -C2 -n --heading --show-function $1 -- '*.tsx'" | zsh
}

function gtd() {
  echo "git tag -d $1 && git push --delete origin $1" | zsh
}

function gcorm() {
  git fetch origin "$1" && git checkout "$1"
}

# ----------------------
# Aliases
# ----------------------
alias cpb='echo $(current_branch) | tr -d "\n" | pbcopy'
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gb='git branch'
alias gbd='git branch -d '
alias gc='git commit'
alias gcm='git commit -m'
alias gcf='git commit --fixup'
alias gcp='git cherry-pick'
alias gcfl='git commit --fixup $(last_commit)'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gd='git diff'
alias gdc='git diff --cached'
alias gda='git diff HEAD'
alias gf='git fetch'
alias gg='git grep -n'
alias ggg='git grep -C2 -n --heading --show-function'
alias gi='git init'
alias gl='git log'
alias gll="git log -4 --pretty=format:\"%ad | %an => '%s' (%h)\" --date=relative | cat"
alias glla="git log -10000 --pretty=format:\"%ad | %an => '%s' (%h)\" --date=relative | cat"
alias gllo="git log -500 --pretty=format:\"%ad | %an => '%s' (%h)\" --date=relative | grep Aleksander"
alias gllla="git log -100000 --pretty=format:\"%ad | %an => '%s' (%h)\" --date=relative | cat"
alias gllh="git log -4 --pretty=format:\"%ad | %H => '%s'\" --date=short | cat"
alias glll="git log -8 --pretty=format:\"%ad | %an => '%s' (%h)\" --date=relative | cat"
alias glllh="git log -8 --pretty=format:\"%ad | %H => '%s'\" --date=short | cat"
alias gllll="git log -16 --pretty=format:\"%ad | %an => '%s' (%h)\" --date=relative | cat"
alias gllllh="git log -16 --pretty=format:\"%ad | %H => '%s'\" --date=short | cat"
alias glllll="git log -32 --pretty=format:\"%ad | %an => '%s' (%h)\" --date=relative | cat"
alias glllllh="git log -32 --pretty=format:\"%ad | %H => '%s'\" --date=short | cat"
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gm='git merge --no-ff'
alias gmm='git merge master'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gpls='git pull && git submodule update'
alias gps='git push'
alias gpsf='git push --force'
alias gpsn='git push --set-upstream origin $(current_branch)'
alias gpst='git push --tags'
alias gr='git reset'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grim='git rebase -i master'
alias gris='git rebase -i --autosquash'
alias grims='git rebase -i --autosquash master'
alias grv='git remote -v | grep push'
alias gs='git status'
alias gsh='git show'
alias gst='git stash'
alias gsta='git stash apply'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gsu='git submodule update'
alias gmfm='gcom && gf && gpl && gco - && gmm'
alias gfpl='gf && gpl'

# Aliases requiring confirmation
alias gca='read REPLY\?"Are you sure you want to amend your last commit? "; if [[ $REPLY =~ ^[Yy]$ ]] git commit --amend'
alias grh='read REPLY\?"Are you sure you want to reset your uncommitted changes? "; if [[ $REPLY =~ ^[Yy]$ ]] git clean -fd && git reset --hard'
alias gpsf='read REPLY\?"Are you sure you want to forcibly push your branch? "; if [[ $REPLY =~ ^[Yy]$ ]] git push --force'
