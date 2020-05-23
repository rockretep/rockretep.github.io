#!/bin/bash

echo "Building HTML..."

pandoc -f markdown_mmd+yaml_metadata_block \
	-t html \
	--template=./index.template \
	-o index.html

DIR="./portfolio"

echo "test"

for file in $DIR/*.md; do
  echo "Processing $file"
  pandoc -f markdown_mmd+smart -t html5 $file --template=$DIR/portfolio.template -o ${file%.md}.html
done
