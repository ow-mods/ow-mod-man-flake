#!/bin/bash
latestRelease=$(curl -s https://api.github.com/repos/ow-mods/ow-mod-man/releases| jq -r ".[0]")
latestTag=$(echo $latestRelease | jq -r ".tag_name")

if [[ $latestRelease != *"gui_v"* ]]; then
  echo "not gui release"
  exit 1
fi
exit $(echo $latestRelease | jq -r "((now - (.published_at | fromdateiso8601) )  / (60*60*24)  | trunc)")
