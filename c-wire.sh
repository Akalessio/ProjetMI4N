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

if [ ! -e "$1" ];then
            echo "==================================================="
            echo "Error CSV File do not exist or wrong File Path argument"
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

if [ "$2" == "--hvb" ] && [ "$3" == "--indiv" ]; then
          echo "==============================================="
          echo "There are no individual connected to HVB station"
          echo "Type ./c-wire.sh -h for help"
          echo "==============================================="
          exit 3
fi

if [ "$2" == "--hva" ] && [ "$3" == "--indiv" ]; then
          echo "==============================================="
          echo "There are no individual connected to HVA station"
          echo "Type ./c-wire.sh -h for help"
          echo "==============================================="
          exit 3
fi

user="$3"

if [ "$2" == "--hvb" ] && [ "$3" == "--all" ]; then
          echo "=========================================================================================="
          echo "There are no individual connected to HVB station so the programm will process only company"
          echo "=========================================================================================="
          user="--comp"
fi

if [ "$2" == "--hva" ] && [ "$3" == "--all" ]; then
          echo "=========================================================================================="
          echo "There are no individual connected to HVA station so the programm will process only company"
          echo "=========================================================================================="
          user="--comp"
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


if [ -z "$4" ]; then
 if [ "$2" == "--hvb"  ]; then
      awk -F';' '
      NR == 1 { print; next }
      {
      if ($2 == "$4" && $3 == "-" && $5 == "-" ){
        $1 = $1 $2
        print
      }

      }' OFS=';' "$filename" > outputstation.csv
      awk -F';' '
          NR == 1 { print; next }
          {
          if ($2 != "-" && $5 != "-" ){
            $1 = $1 $2
            print
          }

          }' OFS=';' "$filename" > outputuser.csv
  fi
  if [ "$2" == "--hva"  ]; then
      awk -F';' '
      NR == 1 { print; next }
      {
      if ($3 != "-" && $4 == "-" && $5 == "-" ){
        $1 = $1 $3
        print
      }

      }' OFS=';' "$filename" > outputstation.csv
      awk -F';' '
          NR == 1 { print; next }
          {
          if ($3 != "-" && $5 != "-" ){
            $1 = $1 $3
            print
          }

          }' OFS=';' "$filename" > outputuser.csv
  fi
  if [ "$2" == "--lv"  ]; then
      awk -F';' '
      NR == 1 { print; next }
      {
      if ($4 != "-" && $5 == "-" && $6 == "-" ){
        $1 = $1 $4
        print
      }

      }' OFS=';' "$filename" > outputstation.csv
      awk -F';' '
          NR == 1 { print; next }
          {
          if ($4 != "-" && ($5 != "-" || $6 != "-")){
            $1 = $1 $4
            print
          }

          }' OFS=';' "$filename" > outputuser.csv
  fi
fi

if [ -n "$4" ]; then

  if [ "$2" == "--hvb"  ]; then
      awk -F';' -v S4="$4" '
      NR == 1 { print; next }
      {
      if ( $1 == S4 && $2 != "-" && $3 == "-" && $5 == "-" ){
        $1 = $1 $2
        print
      }

      }' OFS=';' "$filename" > outputstation.csv
      awk -F';' -v S4="$4" '
          NR == 1 { print; next }
          {
          if ($1 == S4 && $2 != "-" && $5 != "-" ){
            $1 = $1 $2
            print
          }

          }' OFS=';' "$filename" > outputuser.csv
  fi
  if [ "$2" == "--hva"  ]; then
      awk -F';' -v S4="$4" '
      NR == 1 { print; next }
      {
      if ($1 == S4 && $3 != "-" && $4 == "-" && $5 == "-" ){
        $1 = $1 $3
        print
      }

      }' OFS=';' "$filename" > outputstation.csv
      awk -F';' -v S4="$4" '
          NR == 1 { print; next }
          {
          if ($1 == S4 && $3 != "-" && $5 != "-" ){
            $1 = $1 $3
            print
          }

          }' OFS=';' "$filename" > outputuser.csv
  fi
  if [ "$2" == "--lv"  ]; then
      awk -F';' -v S4="$4" '
      NR == 1 { print; next }
      {
      if ($1 == S4 && $4 != "-" && $5 == "-" && $6 == "-" ){
        $1 = $1 $4
        print
      }

      }' OFS=';' "$filename" > outputstation.csv
      awk -F';' -v S4="$4" '
          NR == 1 { print; next }
          {
          if ($1 == S4 && $4 != "-" && ($5 != "-" || $6 != "-")){
            $1 = $1 $4
            print
          }

          }' OFS=';' "$filename" > outputuser.csv
  fi
fi

exec="projetMI4N"

if [ ! -f $exec ]; then
  echo "no executable found, trying compilation with make"
  echo -e "\n\n"
  make clean
  make
  echo -e "\n\n"
  if [ -f $exec ]; then
    echo "compilation done"
  fi
  if [ ! -f $exec ]; then
    echo "compilation with make failed"
    exit 2
  fi
fi



graphdir="graphs"
tmpdir="tmp"

if [ ! -d $graphdir ]; then
    mkdir $graphdir
fi

if [ -d $tmpdir ]; then
    rm -rf $tmpdir
    mkdir $tmpdir
fi

if [ ! -d $tmpdir ]; then
    mkdir $tmpdir
fi

if [ -n "$4" ]; then
    ./$exec "$1" "$2" "$user" "$4"
fi

if [ -z "$4" ]; then
    ./$exec "$1" "$2" "$user"
fi




