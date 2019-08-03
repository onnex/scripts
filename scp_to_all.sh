#!/bin/sh
# scp_to_all.sh - Copy files to multiple machines at the same time via scp.
# Created by onnex @github
# Last modified: 2019-08-02
#
# Change available machines variable according to your need.
# Copying can be done in parallel (default) or sequentially.
# You need passwordless login to all the machines
# in order to copy in parallel.
# In case you don't have that, set parallel_copy variable to 0.
#
# Arguments: $1- -- arguments to scp and files to copy
# Exit values: 0 -- success
#              1 -- internal or configuration error
#              2 -- user input error
#              3 -- both 1 & 2

### USER CONFIGURATION ###
available_machines="mach1 mach2 mach3" # mach1 mach2 ...
parallel_copy=1 # 1 -- parallel, 0 -- sequential
username=${USER} # has to be same for all machines
targetdir=${HOME} # has to be same for all machines


### INITIALIZATION ###
echo 'Running scp_to_all.sh' ; echo
chosen_machines=
args="$@"


### ERROR CHECKING ###
config_error=0
input_error=0

if [ -z "$available_machines" ] ; then
  echo 'Config error: Available machines list empty'
  config_error=1
fi

if [ "$parallel_copy" -ne 0 ] && [ "$parallel_copy" -ne 1 ] ; then
  echo 'Config error: Illegal value in parallel copy setting'
  config_error=1
fi

if [ -z "$username" ] ; then
  echo 'Config error: Username not set'
  config_error=1
fi

if [ -z "$targetdir" ] ; then
  echo 'Config error: Target directory not set'
  config_error=1
fi

if [ -z "$args" ] ; then
  echo 'Input error: No arguments given, nothing to copy'
  input_error=2
fi

error=`expr $config_error + $input_error`
[ "$error" -ne 0 ] && echo 'Exiting.' && exit "$error"


### START OF THE SCRIPT ###
printf "Available machines: %s\n" "$available_machines"
[ "$parallel_copy" -eq 1 ] && echo "Copy mode: parallel"
[ "$parallel_copy" -eq 0 ] && echo "Copy mode: sequential"
printf "Target directory: %s\n\n" "$targetdir"


### CHOOSE TARGET MACHINES ###
for machine in $available_machines ; do

  while :
  do
    printf "Transfer to machine \'%s\' (y/n, default y)? " "$machine"

    read answer
    if [ -z "$answer" ] || [ "$answer" = "y" ] ; then
      chosen_machines="$chosen_machines $machine"
      break
    elif [ "$answer" = "n" ] ; then
      break
    else 
      echo "Please answer y or n"
    fi
  done

done

echo


### CHECK USER INPUT ###
if [ -z "$chosen_machines" ] ; then
  echo 'Input error: No machines selected, exiting.'
  exit 2
fi


### PERFORM COPY ###
printf "Chosen machines:$chosen_machines\n\n"

if [ "$parallel_copy" -eq 1 ] ; then

  echo 'Copying in parallel...' ; echo
  for machine in $chosen_machines ; do
    echo "Copying to $machine"
    scp $args "${username}@${machine}:${targetdir}" & # parallel copy
  done

  wait
  
else 
  
  echo 'Copying sequentially...' ; echo
  for machine in $chosen_machines ; do
    echo "Copying to $machine"
    scp $args "${username}@${machine}:${targetdir}" # sequential copy
  done

fi

echo
echo 'Done'