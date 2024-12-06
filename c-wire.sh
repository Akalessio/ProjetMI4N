#!/bin/bash
argh=0
arge=0



for arg in "$@"; do
    if [ "$arg" == '-h' ]; then
      argh=1
    fi
done

if [ $argh -ne 1 ]; then
    if [ $# -gt 5 ] || [ $# -lt 3 ]; then
      if [ $# -gt 5 ]; then
       echo "==================================="
       echo "Error too many arguments"
       echo "Type ./c-wire.sh -h for help"
       echo "==================================="
        arge=1
      elif [ $# -lt 3 ]; then
        echo "==============================================="
        echo "Error missing arguments"
        echo "Type ./c-wire.sh -h for help"
        echo "==============================================="
        arge=1
      fi
    fi
fi

filename=$(basename "$1")

if [ ! -e $1 ];then
            echo "==================================================="
            echo "Error File do not exist or wrong File Path argument"
            echo "Type ./c-wire.sh -h for help"
            echo "==================================================="
            arge=1
fi

if [ "$2" != "--hva" ] && [ "$2" != "--lv" ] && [ "$2" != "--hvb" ]; then
          echo "==============================================="
          echo "Error wrong Station type argument"
          echo "Type ./c-wire.sh -h for help"
          echo "==============================================="
          arge=1
fi

if [ "$3" != "--comp" ] && [ "$3" != "--indiv" ] && [ "$3" != "--all" ]; then
          echo "==============================================="
          echo "Error wrong User type argument"
          echo "Type ./c-wire.sh -h for help"
          echo "==============================================="
          arge=1
fi



if [ $argh -eq 1 ] || [ $arge -eq 1 ]; then
  echo "this script is used to measure the rate of energy consumption / energy produced of an electrical network and display information for each type of station"
  echo "    Mandatory arguments (in order):"
  echo "        <your/File/Path/yourfile.csv> File Path    : required to access a .csv file with the data of your electrical network"
  echo "        --lv, --hvb, --hva            Station Type : required to treat one type of station on the network"
  echo "        --comp, --indiv, --all        User Type    : required to treat a specific type of user or all the user (comp = company, indiv = individual)"
  echo "    Optional arguments :"
  echo "        a number                      Plant Number : required to treat a specific Power Plant if not specified with process all the Power Plant"
  echo "        -h                            Help         : used to display this help panel"
  exit 202
fi