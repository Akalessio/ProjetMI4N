#include <stdio.h>
#include <stdlib.h>
#include "avl.h"
#include "fonx.h"
#include "csvManaging.h"


int main(int argc, char **argv) {
    //create the station tree
    Station *sevastopol = stationFileReading();

    //count the station
    int stationNumber = 0;
    stationCount(sevastopol, &stationNumber);

    //print the number of station
    printf("\nthere are %d %s station\n\n", stationNumber, argv[2]);

    //add the load to all the station
    sevastopol = userFileReading(sevastopol);

    //create the output file
    createOutputFile(sevastopol, argv[2], argv[3], argv[4]);

    //free the tree
    clearAVL(sevastopol);

    return 0;
}
