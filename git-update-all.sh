#!/usr/bin/env bash
DIR=$(pwd)
printf "Updating git repositories...\n\n"
for i in $(find . -name ".git" | cut -c 3-); do
  printf "$i\n\n" && cd "$i" && cd .. && git pull && cd $DIR
done
echo "Done."
