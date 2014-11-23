#!/bin/bash

flist_fname=.Clean-skip

print_help()
{
  script_name=${0##*/}
  echo "\
usage: $script_name COMMAND
$script_name helps to maintain your direcorty in clean state. You can remove garbage files from your directory with this script.

COMMANDS:
  init            Mark all files contained in the current directory to dont
                  remove them.
  add FILES...    Mark specified files to do not remove them.
  list [-a]       Print new files in current directory. Files, wich will be
                  deleted with command 'del', are marked with '+'.
		  To see all files in current directory use key '-a'.
  del             Delete all files, not marked with command 'init'.
"
}

contains()
{
  local i
  for i in ${flist[@]}; do
    [[ "$1" == "$i" ]] && return 0
  done
  false
}

load_flist(){
  IFS=$'\r\n'
  flist=(`cat $flist_fname 2>/dev/null`)
}


case $1 in
"init")
  rm $flist_fname 2>/dev/null
  for i in *; do
    echo $i >>$flist_fname
  done
  exit 0
  ;;

"add")
  shift
  load_flist
  for i in $@; do
    contains $i || flist+=("$i")
  done

  flist=(`sort <(for j in ${flist[@]}; do echo $j; done)`)
  echo -n >$flist_fname
  for i in ${flist[@]}; do echo $i >>$flist_fname; done
  ;;

"list")
  list_all=0
  shift
  OPTIND=0
  while getopts 'a' opt; do
    case $opt in
    a) list_all=1 ;;
    ?) print_help; exit 1 ;;
    esac
  done
  shift $((OPTIND-1))

  load_flist
  for i in *; do
    if ! contains $i; then
      echo "+$i"
    elif [ "$list_all" != 0 ]; then
      echo " $i"
    fi
  done
  ;;

"del")
  load_flist
  for i in *; do
    if ! contains $i; then
      rm -r $i
      echo -$i
    fi
  done
  ;;

*)
  print_help
  ;;
esac

