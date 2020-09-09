#!/bin/bash

MYPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# SITEPATH="$MYPATH/_site"
SITEPATH="$MYPATH/"
INCLUDES="$MYPATH/includes/"
TEMPLATES="$MYPATH/templates/"
POSTS=($MYPATH/posts/*)

for i in "${POSTS[@]}"
do
	echo $i
done

# mkdir -p $SITEPATH

# echo "Copying assets..."

# cp -R $MYPATH/fonts/ $SITEPATH/fonts/
# cp -r $MYPATH/images/ $SITEPATH/
# while true; do echo n; done | cp -Ri $MYPATH/fonts/ $SITEPATH/fonts/ 2>/dev/null
# while true; do echo n; done | cp -Ri $MYPATH/images/ $SITEPATH/images/ 2>/dev/null

echo "Building CSS..."
mkdir -p $SITEPATH/css
sassc $MYPATH/css/main.scss $SITEPATH/css/main.css

echo "Building HTML..."

pandoc --from=markdown_mmd+yaml_metadata_block+smart \
	--standalone \
	--from=markdown \
	--to=html5 \
	--template=$(TEMPL)/default.template \
	--include-before-body=$(INCLUDE)/header.html \
	--include-after-body=$(INCLUDE)/footer.html
	

# POSTS="posts"
# mkdir -p $SITEPATH/$POSTS
# for file in $POSTS/*.md; do
#   echo "Processing $file"
#   pandoc -f markdown_mmd+yaml_metadata+smart -t html5 $file --template=./templates/post.template -o $SITEPATH/${file%.md}.html
# done

exit 0

# fullpath=$1
# dirpath=$( dirname $1 )
# sourcefile=$( basename $1 )
# targetfile=$(echo "$sourcefile" | cut -f 1 -d '.')'.html'

# creationDate=$( stat -c %w $fullpath | cut -f 1 -d ' ' )
# lastUpdated=$( stat -c %y $fullpath | cut -f 1 -d ' ' )

# echo Processing: $fullpath

# rm $dirpath/$targetfile
# pandoc $fullpath -o $dirpath/$targetfile --standalone --css "/css/milligram.min.css" --css "/css/custom.css" --template=$MY_PATH/template.html --variable=lastUpdated:$lastUpdated --variable=creationDate:$creationDate
