#!/usr/bin/awk -f
# recgrep.awk - Filter for grep's recursive output
# Created by onnex @github
# Last Modified: 2019-08-03
#
# Modify greps output to organized lists of files and matches under filenames
# Use in conjunction with grep -r or grep -nr: 
#  - pipe the output to this script, or 
#  - redirect input from a file containing the output of either command

BEGIN {
  FS=":" 
  prevfile=""
  file="" 
} 

# Remove comment if you want to filter out binary file matches
#!/Binary/ \
{
  prevfile=file
  file=$1
  $1=""
  if (prevfile == file) {
    print $0

  } else {
    printf "\nFILE: %s:\n", file
    print $0
  }
}
