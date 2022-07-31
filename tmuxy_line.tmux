#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmuxy_line_window_default_format="#($CURRENT_DIR/scripts/tmuxy_line_windows.sh default_format)"
tmuxy_line_window_start_format="($CURRENT_DIR/scripts/tmuxy_line_windows.sh start_format)"
tmuxy_line_window_end_format="($CURRENT_DIR/scripts/tmuxy_line_windows.sh end_format)"
tmuxy_line_window_format_interpolation_string="\#{tmuxy_line_window_format}"

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}

set_tmux_option_with_specificity() {
  local option="$1"
  local value="$2"
  local specificity_args="$3"
  tmux set-option "$specificity_args" "$option" "$value"
}
do_interpolation() {
	local string="$1"
	local new_format="$2"
	local interpolated="${string/$tmuxy_line_window_format_interpolation_string/$new_format)}"
	echo "$interpolated"
}

update_tmux_option() {
	local option="$1"
	local updated_format="$2"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value" "$updated_format")"
	set_tmux_option "$option" "$new_option_value"
}

update_tmux_option_with_specificity() {
  local option="$1"
  local updated_format="$2"
  local specificity_args="$3"

  local option_value="$(get_tmux_option "$specificity_args" "$option")"
  local new_option_value=$(do_interpolation "$option_value" "$updated_format")
  set_tmux_option_with_specificity "$option" "$new_option_value" "$specificity_args"
}

main() {
  update_tmux_option "window-status-format" "$tmuxy_line_window_default_format"
  update_tmux_option_with_specificity "window-status-format" "$tmuxy_line_window_start_format" "-w -t :1"
}
main
