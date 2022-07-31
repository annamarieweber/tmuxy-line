#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmuxy_line_window_format="#($CURRENT_DIR/scripts/tmuxy_line_windows.sh)"
tmuxy_line_window_format="this is a test"
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
do_interpolation() {
	local string="$1"
	local interpolated="${string/$tmuxy_line_window_format_interpolation_string/$tmuxy_line_window_format}"
	echo "$interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "window-status-format"
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}
main
