#!/bin/sh
# scd.sh - cd to a path with spaces in it
# Created by onnex @github 
# Last modified: 2019-08-03
#
# Useful script if path to cd is taken from e.g. environment variable
# Arguments: $1- -- path to target directory
# Exit values: 0 -- success
#              1 -- empty argument list

if [ -z "$1" ] ; then
  echo 'scd: no arguments given'
  exit 1
else
  cd "$*"
fi
