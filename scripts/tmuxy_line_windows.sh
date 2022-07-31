#!/usr/bin/env bash

main(){
  styling_component="$1"
  main_component="[bg=colour13] #I#[fg=colour237,bg=colour13]:#[fg=colour250,bg=colour13]#W#[fg=colour244,bg=colour13]#F "

  if [[ $styling_component == "default_format" ]]; then
    echo "$main_component"
  else if [[ $styling_component == "start_format" ]]; then
    echo "[fg=colour13,bg=colour237]$main_component"
  else if [[ $styling_component == "end_format" ]]; then 
    echo "$main_component[fg=colour13,bg=colour237]"
  fi
}

main

