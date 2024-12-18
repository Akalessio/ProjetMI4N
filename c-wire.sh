#!/bin/bash
argh=0
arge=0

start_time=$(date +%s)

find . -name "*.csv" -type f -delete

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
  if [ "$2" == "--lv" ]; then
    awk -F';' -v mode="$3" '
    BEGIN { OFS=";" }
    NR == 1 {
      # Print headers to both files
      print > "tmp/outputstation.csv"
      print > "tmp/outputuser.csv"
      next
    }
    {
      # Always process stations
      if ($4 != "-" && $5 == "-" && $6 == "-") {
        $1 = $1 $4
        print > "tmp/outputstation.csv"
      }

      # Process users based on mode
      if (mode == "--all" && $4 != "-" && ($5 != "-" || $6 != "-")) {
        $1 = $1 $4
        print > "tmp/outputuser.csv"
      }
      else if (mode == "--comp" && $4 != "-" && $5 != "-") {
        $1 = $1 $4
        print > "tmp/outputuser.csv"
      }
      else if (mode == "--indiv" && $4 != "-" && $6 != "-") {
        $1 = $1 $4
        print > "tmp/outputuser.csv"
      }
    }' "$filename"
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
  if [ "$2" == "--lv" ]; then
    awk -F';' -v S4="$4" -v mode="$3" '
    BEGIN { OFS=";" }
    NR == 1 {
      # Print header to both files once
      print > "tmp/outputstation.csv"
      print > "tmp/outputuser.csv"
      next
    }
    {
      # Always process stations
      if ($1 == S4 && $4 != "-" && $5 == "-" && $6 == "-") {
        $1 = $1 $4
        print > "tmp/outputstation.csv"
      }

      # Process users based on mode
      if (mode == "--all" && $1 == S4 && $4 != "-" && ($5 != "-" || $6 != "-")) {
        $1 = $1 $4
        print > "tmp/outputuser.csv"
      }
      else if (mode == "--comp" && $1 == S4 && $4 != "-" && $5 != "-") {
        $1 = $1 $4
        print > "tmp/outputuser.csv"
      }
      else if (mode == "--indiv" && $1 == S4 && $4 != "-" && $6 != "-") {
        $1 = $1 $4
        print > "tmp/outputuser.csv"
      }
    }' "$filename"
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

lv_all_plant="lv_all_$4.csv"
lv_indiv_plant="lv_indiv_$4.csv"
lv_comp_plant="lv_comp_$4.csv"
hvb_comp_plant="hvb_comp_$4.csv"
hva_comp_plant="hva_comp_$4.csv"

if [ -f lv_all.csv ]; then
    head -n 1 "lv_all.csv" > lv_all_minmax.csv
    sort -t ':' -k4,4nr "lv_all.csv" | head -n 10 >> lv_all_minmax.csv
    sort -t ':' -k4,4n "lv_all.csv" | head -n 10 >> lv_all_minmax.csv
    sort -t ':' -k2,2n "lv_all.csv" >> tmp/sorting_file && mv tmp/sorting_file "lv_all.csv"
    sort -t ':' -k1,1n "lv_all_minmax.csv" >> tmp/sorting_file2 && mv tmp/sorting_file2 "lv_all_minmax.csv"
fi
if [ -f "$lv_all_plant" ]; then
    head -n 1 "$lv_all_plant" > lv_all_minmax.csv
    sort -t ':' -k4,4nr "$lv_all_plant" | head -n 10 >> lv_all_minmax.csv
    sort -t ':' -k4,4n "$lv_all_plant" | head -n 10 >> lv_all_minmax.csv
    sort -t ':' -k2,2n "$lv_all_plant" >> tmp/sorting_file && mv tmp/sorting_file "$lv_all_plant"
    sort -t ':' -k1,1n "lv_all_minmax.csv" >> tmp/sorting_file2 && mv tmp/sorting_file2 "lv_all_minmax.csv"
fi
if [ -f "$lv_all_plant" ]; then
    head -n 1 "$lv_all_plant" > lv_all_minmax.csv
    sort -t ':' -k4,4nr "$lv_all_plant" | head -n 10 >> lv_all_minmax.csv
    sort -t ':' -k4,4n "$lv_all_plant" | head -n 10 >> lv_all_minmax.csv
    sort -t ':' -k2,2n "$lv_all_plant" >> tmp/sorting_file && mv tmp/sorting_file "$lv_all_plant"
fi
if [ -f lv_comp.csv ]; then
    sort -t ':' -k2,2n "lv_comp.csv" >> tmp/sorting_file && mv tmp/sorting_file "lv_comp.csv"
fi
if [ -f "$lv_comp_plant" ]; then
    sort -t ':' -k2,2n "$lv_comp_plant" >> tmp/sorting_file && mv tmp/sorting_file "$lv_comp_plant"
fi
if [ -f lv_indiv.csv ]; then
    sort -t ':' -k2,2n "lv_indiv.csv" >> tmp/sorting_file && mv tmp/sorting_file "lv_indiv.csv"
fi
if [ -f "$lv_indiv_plant" ]; then
    sort -t ':' -k2,2n "$lv_indiv_plant" >> tmp/sorting_file && mv tmp/sorting_file "$lv_indiv_plant"
fi
if [ -f hvb_comp.csv ]; then
    sort -t ':' -k2,2n "hvb_comp.csv" >> tmp/sorting_file && mv tmp/sorting_file "hvb_comp.csv"
fi
if [ -f "$hvb_comp_plant" ]; then
    sort -t ':' -k2,2n "$hvb_comp_plant" >> tmp/sorting_file && mv tmp/sorting_file "$hvb_comp_plant"
fi
if [ -f hva_comp.csv ]; then
    sort -t ':' -k2,2n "hva_comp.csv" >> tmp/sorting_file && mv tmp/sorting_file "hva_comp.csv"
fi
if [ -f "$hva_comp_plant" ]; then
    sort -t ':' -k2,2n "$hva_comp_plant" >> tmp/sorting_file && mv tmp/sorting_file "$hva_comp_plant"
fi

end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "the second sort process lasted for ${elapsed_time} seconds"
echo -e "\n"
start_time=$(date +%s)

gnuplot <<EOF
set terminal png size 1200,800
set output "graphs/minmaxgraphs.png"
set xlabel "stations ID"
set ylabel "kWh"
set grid
set datafile separator ":"
set style line 1 lc rgb "red"
set style line 2 lc rgb "blue"
set style fill solid
set boxwidth 0.4
set xtics rotate by -45
set offset 0,0,0,0

plot "lv_all_minmax.csv" using (column(0)):2:xtic(1) with boxes title 'capacity' ls 1, \
     "lv_all_minmax.csv" using (column(0)+0.4):3 with boxes ls 2 title 'load'

EOF
