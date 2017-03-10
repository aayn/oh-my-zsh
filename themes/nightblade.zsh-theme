function get_pwd() {
  echo "${PWD/$HOME/~}"
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
      ((git=${#git} - 10))
  else
      git=0
  fi

  local virt=$(virtualenv_info)

  local termwidth
  (( termwidth = ${COLUMNS} - 3- ${#HOST} - ${#$(get_pwd)} - ${git} - ${#virt} - 10 ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} "
  done
  echo $spacing
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT='$fg[cyan]%m: $fg[red]$(get_pwd)$(put_spacing) $(git_prompt_info)
$reset_color→ '
