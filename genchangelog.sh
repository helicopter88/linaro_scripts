#!/bin/sh

# Exports
export Changelog=changelog.txt

if [ -f $Changelog ];
then
        rm -f $Changelog
fi

touch $Changelog

# Print something to build output
echo "Generating changelog..."

for i in $(seq $1); do
	echo [$i/$1]
	export After_Date=`date --date="$i days ago" +%d-%m-%Y`
	k=$(expr $i - 1)
        export Until_Date=`date --date="$k days ago" +%d-%m-%Y`
        # Line with after --- until was too long for a small ListView
        echo '--  ' $Until_Date  >> $Changelog
        echo >> $Changelog;

        # Cycle through every repo to find commits between 2 dates
        repo forall -pc 'git log --format="| Commit: %h | Title: %s | By: %an " --reverse --after=$After_Date --until=$Until_Date' >> $Changelog
        echo >> $Changelog;
done
