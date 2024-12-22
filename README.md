# Projet C-Wire

This project realised by the MI4N group makes it possible to synthesize data from an electricity distribution system.

## Programm 
the programm is divided in 2 parts : 

### -The C code
in the codeC folder you can find the following files :

.h in the "/include" folder

.c in the "/src" folder

and .o in the "/obj" folder

and the Makefile which will compile into the target executable named "projetMI4N"

### -the Shell script
named c-wire.sh this script is used to start the programm compile a C executable if its not already existing and process the given file with the specific argument into another .csv file 

(or two in the lv all case which will genereate the lv_all_minmax.csv file and a graph)

```bash
./c-wire.sh arg1 arg2 arg3 arg4
```
#### arg1 should alawys be the csv file path for example if the file is named "c-wire_v25.dat" the argument will be 
```bash
./c-wire.sh input/c-wire_v25.dat arg2 arg3 arg4
```
#### arg2 should alawys be the station type
there are 3 type lv, hva, hvb and there are always preceded by "--" for example if you want to process the lv type
```bash
./c-wire.sh input/c-wire_v25.dat --lv arg3 arg4
```
#### arg3 should alawys be the user type
there are 3 type comp, indiv, all and there are always preceded by "--" for example if you want to process the all type
```bash
./c-wire.sh input/c-wire_v25.dat --lv --all arg4
```
#### arg4 is optional
it should be a number based on the number of powerPlant if the power Plant is not existing it should return an empty .csv file
```bash
./c-wire.sh input/c-wire_v25.dat --lv --all 1
```
or no specific power plant :
```bash
./c-wire.sh input/c-wire_v25.dat --lv --all
```

## special features of the project
 
- Our project includes a bar graph of the 10 most loaded LV posts, and the 10 least busy LV posts. made using gnuplot
- in the rendered file the station identifier is modified to have as the first digit the number of the central unit to which it is connected and then directly pasted the identifier


 ## Contributors

- [@Wielss](https://github.com/Wielss)
- [@Akalessio](https://github.com/Akalessio)
- [@SteakBlack](https://github.com/SteakBlack)
