#!/bin/sh
#/ Usage: pixeltesting -h <host> [-c]
#/ Pixel testing
set -e

test $# -eq 0 && {
    grep '^#/' <"$0" |
    cut -c4-
    exit 2
}


OUTPUT="output/"

function render {
  phantomjs render.js $1 $2 320 2000
}


function render_cookpad {
  host=$1
  output=$2
  render $host'/' $output'top.png'

  render $host'/recipe/hot' $output'hot.png'

  render $host'/diary/1591399' $output'diary_top.png'
  render $host'/diary/list/57172' $output'diary_list.png'
  render $host'/diary/list/1386727' $output'empty_diary_list.png'

  render $host'/recipe/692226' $output'recipe.png'
  render $host'/recipe/list/57172' $output'recipe_list.png'

  render $host'/recipe/tsukurepo_list_by_recipe/209435' $output'tsukurepo_list_by_recipe.png'
  render $host'/tsukurepo/list/434295' $output'tsukurepo_list.png'

  render $host'/login' $output'login.png'
  render $host'/user/regist' $output'regist.png'
  render $host'/mobile' $output'mobile.png'
  render $host'/terms' $output'terms.png'
  render $host'/terms/privacy' $output'privacy.png'
  render $host'/terms/tokutei' $output'tokutei.png'
  render $host'/terms/ps' $output'ps.png'
}


function create_ref {
  echo "Creating reference"

  if [ -d reference ]; then
    rm -rf reference
  fi

  mkdir reference
  render_cookpad "$HOST" "reference/"
}

function compare_with_ref {
  echo "Creating screenshots of Cookpad"

  if [ -d output ]; then
    rm -rf output
  fi

  mkdir output
  render_cookpad "$HOST" "output/"

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


MODE="default"
HOST=""

while getopts "h:c" optionName; do
case "$optionName" in
h)  HOST=$OPTARG
    ;;
c)  MODE="reference"
    ;;
*)  grep '^#/' <"$0" |
    cut -c4-
    exit 2
    ;;
esac
done

if [ "$MODE" == "reference" ]; then
  create_ref
else
  compare_with_ref
fi


