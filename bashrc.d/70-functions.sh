#!/usr/bin/env bash

repo() {
  export REPO="$1"
}

g() {

  # Change to a git repo
  # --------------------

  local target
  local repo

  # Look for a repo name in case a short form is given
  repo=$(grep -E "^$1\s" "$HOME/.config/g/config.txt" | cut -f 2)

  # Fall back to what was originally given if a short form can't be resolved
  repo=${repo:-$1}

  target=$(
    find "$WORK/gh" -mindepth 3 -maxdepth 3 -type d \
      | sed -E 's/^(.+\/gh(\/.+?))$/\2\t\1/' \
      | fzf --with-nth=1 --select-1 --query="$repo" --height=60% --reverse \
      | cut -f 2
  )

  if [[ -n "$target" ]]; then
    cd "$target" && ls -a && git status --short --branch
  fi

}

authenv() {

  # Export env vars for auth, for a given service
  # and identify (default 'qmacro').
  local service=$1
  local identity=${2:-qmacro}
  if [[ -z $service ]]; then
    echo "Specify service e.g. strava, youtube and optional identity (default qmacro)"
  else
    echo -n "Setting $identity auth env vars "
    local envvar
    for file in "$HOME/.auth/$service/$identity/"*; do
      envvar="${service^^}_$(basename "$file")"
      export "$envvar"="$(cat "$file")"
      echo -n "$envvar "
    done
    echo
  fi

}

search() {
  local IFS="+"
  open "https://google.com/search?q=$*"
}

focus() {
  echo "$*" | tee "$HOME/.focus" > "$HOME/.status"
}


nd() {
  # Create new directory and cd into it
  mkdir "$1" && { cd $_ || :; }
}


addpath() {

  export PATH="$PATH:$PWD"

}
