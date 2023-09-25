#!/bin/sh
echo -ne '\033c\033]0;GogolJump\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/GogolJump2.x86_64" "$@"
