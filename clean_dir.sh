#!/bin/bash

flist_fname=.Clean-skip

if [[ "$1" == "init" ]]; then
  rm $flist_fname 2>/dev/null
  for i in *; do
    echo $i >>$flist_fname
  done
  exit 0
fi

contains()
{
  local i
  for i in ${flist[@]}; do
    [[ "$1" == "$i" ]] && return 0
  done
  false
}

IFS=$'\r\n'
flist=(`cat $flist_fname`)

if [[ "$1" == "list" ]]; then
  for i in *; do
    prefix=" "
    contains $i || prefix="+"
    echo ${prefix}$i
  done
fi

if [[ "$1" == "del" ]]; then
  for i in *; do
    if ! contains $i; then
      #rm -r $i
      echo -$i
    fi
  done
fi

