#!/bin/bash
argh=0
arge=0

start_time=$(date +%s)

if [ -f lv_all.csv ]; then
    rm -rf lv_all.csv
fi
if [ -f lv_comp.csv ]; then
    rm -rf lv_comp.csv
fi
if [ -f lv_indiv.csv ]; then
    rm -rf lv_indiv.csv
fi
if [ -f hvb_comp.csv ]; then
    rm -rf hvb_comp.csv
fi
if [ -f hva_comp.csv ]; then
    rm -rf hva_comp.csv
fi


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

filename="input/$(basename "$1")"

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
    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))
    echo "the whole process ended prematurely and last ${elapsed_time} second"
    exit 202
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

if [ -z "$4" ]; then
 if [ "$2" == "--hvb"  ]; then
      awk -F';' '
      NR == 1 { print; next }
      {
      if ($2 != "-" && $3 == "-" && $5 == "-" ){
        $1 = $1 $2
        print
      }

      }' OFS=';' "$filename" > tmp/outputstation.csv
      awk -F';' '
          NR == 1 { print; next }
          {
          if ($2 != "-" && $5 != "-" ){
            $1 = $1 $2
            print
          }

          }' OFS=';' "$filename" > tmp/outputuser.csv
  fi
  if [ "$2" == "--hva"  ]; then
      awk -F';' '
      NR == 1 { print; next }
      {
      if ($3 != "-" && $4 == "-" && $5 == "-" ){
        $1 = $1 $3
        print
      }

      }' OFS=';' "$filename" > tmp/outputstation.csv
      awk -F';' '
          NR == 1 { print; next }
          {
          if ($3 != "-" && $5 != "-" ){
            $1 = $1 $3
            print
          }

          }' OFS=';' "$filename" > tmp/outputuser.csv
  fi
  if [ "$2" == "--lv"  ]; then
      awk -F';' '
      NR == 1 { print; next }
      {
      if ($4 != "-" && $5 == "-" && $6 == "-" ){
        $1 = $1 $4
        print
      }

      }' OFS=';' "$filename" > tmp/outputstation.csv
     if [ "$3" == "--all" ]; then
               awk -F';' '
                         NR == 1 { print; next }
                         {
                         if ($4 != "-" && ($5 != "-" || $6 != "-")){
                           $1 = $1 $4
                           print
                         }

                         }' OFS=';' "$filename" > tmp/outputuser.csv
           fi
           if [ "$3" == "--comp" ]; then
                    awk -F';' '
                              NR == 1 { print; next }
                              {
                              if ($4 != "-" && $5 != "-"){
                                $1 = $1 $4
                                print
                              }

                              }' OFS=';' "$filename" > tmp/outputuser.csv
           fi
           if [ "$3" == "--indiv" ]; then
                    awk -F';' '
                              NR == 1 { print; next }
                              {
                              if ($4 != "-" && $6 != "-"){
                                $1 = $1 $4
                                print
                              }

                              }' OFS=';' "$filename" > tmp/outputuser.csv
           fi
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

      }' OFS=';' "$filename" > tmp/outputstation.csv
      awk -F';' -v S4="$4" '
          NR == 1 { print; next }
          {
          if ($1 == S4 && $2 != "-" && $5 != "-" ){
            $1 = $1 $2
            print
          }

          }' OFS=';' "$filename" > tmp/outputuser.csv
  fi
  if [ "$2" == "--hva"  ]; then
      awk -F';' -v S4="$4" '
      NR == 1 { print; next }
      {
      if ($1 == S4 && $3 != "-" && $4 == "-" && $5 == "-" ){
        $1 = $1 $3
        print
      }

      }' OFS=';' "$filename" > tmp/outputstation.csv
      awk -F';' -v S4="$4" '
          NR == 1 { print; next }
          {
          if ($1 == S4 && $3 != "-" && $5 != "-" ){
            $1 = $1 $3
            print
          }

          }' OFS=';' "$filename" > tmp/outputuser.csv
  fi
  if [ "$2" == "--lv"  ]; then
      awk -F';' -v S4="$4" '
      NR == 1 { print; next }
      {
      if ($1 == S4 && $4 != "-" && $5 == "-" && $6 == "-" ){
        $1 = $1 $4
        print
      }

      }' OFS=';' "$filename" > tmp/outputstation.csv
      if [ "$3" == "--all" ]; then
          awk -F';' -v S4="$4" '
                    NR == 1 { print; next }
                    {
                    if ($1 == S4 && $4 != "-" && ($5 != "-" || $6 != "-")){
                      $1 = $1 $4
                      print
                    }

                    }' OFS=';' "$filename" > tmp/outputuser.csv
      fi
      if [ "$3" == "--comp" ]; then
               awk -F';' -v S4="$4" '
                         NR == 1 { print; next }
                         {
                         if ($1 == S4 && $4 != "-" && $5 != "-"){
                           $1 = $1 $4
                           print
                         }

                         }' OFS=';' "$filename" > tmp/outputuser.csv
      fi
      if [ "$3" == "--indiv" ]; then
               awk -F';' -v S4="$4" '
                         NR == 1 { print; next }
                         {
                         if ($1 == S4 && $4 != "-" && $6 != "-"){
                           $1 = $1 $4
                           print
                         }

                         }' OFS=';' "$filename" > tmp/outputuser.csv
      fi
  fi
fi

end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "the sort process lasted for ${elapsed_time} seconds"
start_time=$(date +%s)

exec="projetMI4N"

if [ ! -f $exec ]; then
  echo -e "\n"
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

if [ -n "$4" ]; then
    ./$exec "$1" "$2" "$user" "$4"
fi

if [ -z "$4" ]; then
    ./$exec "$1" "$2" "$user"
fi

end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "the C process lasted for ${elapsed_time} seconds"
start_time=$(date +%s)

if [ -f lv_all.csv ]; then
    head -n 1 "lv_all.csv" > lv_all_minmax.csv
    sort -t ':' -k4,4nr "lv_all.csv" | head -n 10 >> lv_all_minmax.csv
    sort -t ':' -k4,4n "lv_all.csv" | head -n 10 >> lv_all_minmax.csv
    head -n 1 "lv_all.csv" > tmp/sorting_file
    sort -t ':' -k2,2n "lv_all.csv" >> tmp/sorting_file && mv tmp/sorting_file "lv_all.csv"
fi
if [ -f lv_comp.csv ]; then
    head -n 1 "lv_comp.csv" > tmp/sorting_file
    sort -t ':' -k2,2n "lv_comp.csv" >> tmp/sorting_file && mv tmp/sorting_file "lv_comp.csv"
fi
if [ -f lv_indiv.csv ]; then
    head -n 1 "lv_indiv.csv" > tmp/sorting_file
    sort -t ':' -k2,2n "lv_indiv.csv" >> tmp/sorting_file && mv tmp/sorting_file "lv_indiv.csv"
fi
if [ -f hvb_comp.csv ]; then
    head -n 1 "hvb_comp.csv" > tmp/sorting_file
    sort -t ':' -k2,2n "hvb_comp.csv" >> tmp/sorting_file && mv tmp/sorting_file "hvb_comp.csv"
fi
if [ -f hva_comp.csv ]; then
    head -n 1 "hva_comp.csv" > tmp/sorting_file
    sort -t ':' -k2,2n "hva_comp.csv" >> tmp/sorting_file && mv tmp/sorting_file "hva_comp.csv"
fi

end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "the second sort process lasted for ${elapsed_time} seconds"
echo -e "\n"
start_time=$(date +%s)






