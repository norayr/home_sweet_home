#!/usr/bin/env bash

# This can be run simply by passing it the outputs from pgrep:
# my_renice $(pgrep application)
#
# You may also want to use pgrep to find more complex
#    processes based on arguments
# my_renice $(pgrep -f "bash.*$name")

set -x
	function my_renice(){
  newnice=19
  pid=$1

  # Return if pid not found
  if [ -z $pid ]; then return; fi

  # Renice pid right away in case we spawn more children
  renice $newnice $pid

  # Find children pids
  children=$(pgrep -d ' ' -P $pid)

  # Loop through children
  for i in $children; do my_renice $i; done
	}
  my_renice $(pgrep qemu)
