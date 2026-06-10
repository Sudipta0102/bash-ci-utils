#!/usr/bin/env bash

DIR="/home/user/projects"
filepath="/home/user/projects/src/main.go"

relative_path="${filepath#$DIR/}"

echo "$relative_path"