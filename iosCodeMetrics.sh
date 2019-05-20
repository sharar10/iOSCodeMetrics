#!/bin/bash

if [ $# -eq 0 ]; then
   echo "Program takes at least on dir"
   exit 1
fi

divider="----------------------"

for var in "$@"
do
   if ! [[ -d $var ]]; then
      echo \"$var\" is not a directory
      continue
   fi
   echo iOS code metrics for $var
   echo $divider
   codeM=$(find $var -name "*.m" | xargs wc -l 2> /dev/null | grep total | grep -o -E '[0-9]+')
   codeH=$(find $var -name "*.h"| xargs wc -l 2> /dev/null | grep total | grep -o -E '[0-9]+')
   codeS=$(find $var -name "*.swift"| xargs wc -l 2> /dev/null | grep total | grep -o -E '[0-9]+')
   numStoryboards=$(find $var -name "*.storyboard" | wc -l 2> /dev/null)
   numXibs=$(find $var -name "*.xib" | wc -l 2> /dev/null)
   totalCode=$((codeM + codeH + codeS))
   totalObjC=$((codeH + codeM))
   objCP=`echo $totalObjC/$totalCode*100|bc -l`
   swiftP=`echo $codeS/$totalCode*100|bc -l`
   printf "obj-c usage %0.3f%%\n" $objCP
   printf "swift usage %0.3f%%\n" $swiftP
   echo number of storyboards: $numStoryboards
   echo number of xibs: $numXibs
   echo $divider
   echo obj-c LOC .h + .m: $totalObjC
   echo swift LOC: $codeS
   echo total LOC: $totalCode
   echo $divider
done

