#!/bin/sh
#/ Pixel testing
#/ Usage: pixeltesting -c <config file> [-r]
set -e

test $# -eq 0 && {
    grep '^#/' <"$0" |
    cut -c4-
    exit 2
}


OUTPUT="output/"

function render {
  phantomjs render.js $1 $2 320 2000 "$USER_AGENT"
}


function render_cookpad {

  prefix=$1
  line_num=0

  while read line
  do
    line_num=`expr $line_num + 1`

    if [ $line_num -eq 1 ]; then
      name=$line

      if [ ! -d $name ]; then
        mkdir $name
      fi

      if [ -d $name/$prefix ]; then
        rm -rf $name/$prefix
      fi
      mkdir $name/$prefix


    elif [ $line_num -eq 2 ]; then
      host=$line
    elif [ $line_num -eq 3 ]; then
      USER_AGENT=$line
    else
      filename=`expr $line_num - 3`
      render $host$line $name/$prefix/$filename'.png'
    fi
  done < $CONFIG_FILE

}


function create_ref {
  echo "Creating reference"

  render_cookpad "ref"
}

function compare_with_ref {
  echo "Creating screenshots of Cookpad"

  render_cookpad "out"
  read -r name < $CONFIG_FILE
  cd $name/out
  echo "Comparing"
  rm -rf tmp
  mkdir tmp
  for i in *
  do
      if test -f "$i"
      then

        w1=`identify -format "%w" "../ref/"$i`
        w2=`identify -format "%w" $i`
        h1=`identify -format "%h" "../ref/"$i`
        h2=`identify -format "%h" $i`
        if [ $w1 == $w2 -a $h1 == $h2 ]; then
          compare $i "../ref/"$i "tmp/"$i
        else
          # compare -subimage-search "../reference/"$i $i "tmp/"$i
          echo "-> Different image sizes for "$i
        fi
      fi
  done

  if [ -d tmp ]; then
    echo "Merging"
    cd tmp
    mergedfile=`date "+%Y%m%d%H%M%S"`".png"
    if [ -e $mergedfile ]; then
      rm $mergedfile
    fi

    for i in *
    do
      if [ -e $mergedfile ]; then
        montage -geometry +0+0 $i $mergedfile $mergedfile
      else
        montage -geometry +0+0 $i $mergedfile
      fi
    done
    open $mergedfile
  fi

}


MODE="default"
HOST=""
CONFIG_FILE=""
USER_AGENT=""

while getopts "c:r" optionName; do
case "$optionName" in
c)  CONFIG_FILE=$OPTARG
    ;;
r)  MODE="reference"
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

