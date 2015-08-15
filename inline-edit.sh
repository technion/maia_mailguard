#/bin/bash

DBG=0

old_str=$1
new_str=$2
filename=$3

[ $DBG -eq 0 ] || 
[ $DBG -eq 0 ] || echo "argc = $#"
[ $# -eq 3 ] || exit 255
[ $DBG -eq 0 ] || echo "old string = $old_str"
[ $DBG -eq 0 ] || echo "new string = $new_str"
[ $DBG -eq 0 ] || echo "filename = $filename"

echo "perl -p -e 's/"$old_str"/"$new_str"/g' $filename" 
[ $DBG -eq 0 ] || echo "ready?"
[ $DBG -eq 0 ] || read junk
perl -pi -e "s/$old_str/$new_str/g" $filename
