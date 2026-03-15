#!/bin/sh
printf '\033c\033]0;%s\a' Trivia Marathon
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Trivia_Marathon_Test_Build_8.3.2026.x86_64" "$@"
