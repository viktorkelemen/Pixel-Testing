#!/bin/sh
#/ Usage: pixeltesting [--createref <optional>]
#/ Pixel testing
set -e

# test $# -eq 0 -o "$1" = "--help" && {
#     grep '^#/' <"$0" |
#     cut -c4-
#     exit 2
# }

HOST="http://cookpad.local.com:3000"
# HOST="http://cookpad.com"
OUTPUT="output/"

function render {
  phantomjs render.js $1 $2 320 1000
}

function render_cookpad {
  host=$1
  output=$2
  render $host'/?fmt=smt' $output'cookpad_top.png'
  render $host'/diary/1591399?fmt=smt' $output'cookpad_diary.png'
  render $host'/diary/list/57172?fmt=smt' $output'cookpad_diary_list.png'
  render $host'/diary/list/1386727?fmt=smt' $output'cookpad_diary_list_empty.png'

  render $host'/recipe/list/57172?fmt=smt' $output'cookpad_recipe_list.png'
  render $host'/recipe/692226?fmt=smt' $output'cookpad_recipe.png'
  render $host'/recipe/tsukurepo_list_by_recipe/209435?fmt=smt' $output'cookpad_tsukurepo_list_by_recipe.png'

  render $host'/login?fmt=smt' $output'cookpad_login.png'
  render $host'/mobile?fmt=smt' $output'cookpad_mobile.png'

  render $host'/tsukurepo/list/434295?fmt=smt' $output'cookpad_tsukurepo_list.png'
}


function create_ref {
  echo "Creating reference"

  if [ -d reference ]; then
    rm -rf reference
  fi

  render_cookpad $HOST "reference/"
}

function compare_with_ref {
  echo "Creating screenshots of Cookpad"

  if [ -d output ]; then
    rm -rf output
  fi

  render_cookpad $HOST "output/"

  # mkdir output
  cd output
  echo "Comparing"
  mkdir tmp
  for i in *
  do
      if test -f "$i" 
      then

        w1=`identify -format "%w" "../reference/"$i`
        w2=`identify -format "%w" $i`
        h1=`identify -format "%h" "../reference/"$i`
        h2=`identify -format "%h" $i`
        if [ $w1 == $w2 -a $h1 == $h2 ]; then
          compare $i "../reference/"$i "tmp/"$i
        else
          # compare -subimage-search "../reference/"$i $i "tmp/"$i
          echo "-> Different image sizes for "$i
        fi
      fi
  done

  if [ -d tmp ]; then
    echo "Merging"
    cd tmp
    if [ -e test.png ]; then
      rm test.png
    fi

    for i in *
    do
      if [ -e "test.png" ]; then
        montage -geometry +0+0 $i "test.png" "test.png"
      else
        montage -geometry +0+0 $i "test.png"
      fi
    done
    open test.png
  fi

}

if [ "$1" == "--createref" ]; then
  create_ref
else
  compare_with_ref
fi


