#!/bin/bash

DIR="portfolio"

for file in $DIR/*.md; do
  echo "Processing $file"
  pandoc -f markdown -t html $file  --template=portfolio_template.html -o ${file%.md}.html
done
