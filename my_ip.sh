#!/bin/bash
# my_ip.sh - get own ip
# Created by onnex @github
# Last modified: 2021-12-22
#
# Returns ip address of a given network device(s) or a default device
# Script can also be sourced to get the my_ip function as an available command
# Multiple devices can be specified by giving multiple arguments
#
# Arguments: $1- -- Network device (Optional, can also be >1)
#                   Can be either an actual device (e.g. eth0, wlp3s0 etc.)
#                   or the script can decide the device from the argument
#                   (possible arguments in that case: 
#                   l/lo/loopback,
#                   e/eth/ethernet,
#                   w/wlan/wifi,
#                   d/def/default or blank).
#                   The first device that matches, or the default will be used.
#
# Exit values: 0 -- Success
#              1 -- Error, most likely the given device does not exist or
#                   it does not have an ip address

my_ip() {
  local default_interface='e' # e=eth, w=wlan
  local interface="${1:-default}" ; shift

  while [ "$interface" ] ; do

    case "$interface" in
      l|lo|loopback)
        interface="lo"
        ;;
      e|eth|ethernet)
        interface=`ip link | sed '/^.*: e/!d' | cut -d' ' -f 2 | cut -d ':' -f 1`
        ;;
      w|wlan|wifi|wireless)
        interface=`ip link | sed '/^.*: w/!d' | cut -d' ' -f 2 | cut -d ':' -f 1`
        ;;
      d|def|default)
        interface=`ip link | sed "/^.*: $default_interface/!d" | cut -d' ' -f 2 | cut -d ':' -f 1`
        ;;
    esac

    # Check if interface exists
    ip addr show $interface >> /dev/null || exit $?

    ip addr show $interface | sed -n 3p | awk '{print $2}' | cut -d'/' -f1

    interface="$1" ; shift # get next argument
  done
}


# Run the script if the script is executed directly instead of sourcing
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    my_ip ${1+"$@"}
fi

