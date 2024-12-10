#include <stdio.h>
#include <stdlib.h>
#include "avl.h"
#include "fonx.h"
#include "csvManaging.h"


int main(int argc, char **argv) {
    Station *sevastopol = stationFileReading();

    int stationNumber = 0;
    stationCount(sevastopol, &stationNumber);

    printf("\nthere are %d %s station\n\n", stationNumber, argv[2]);

    sevastopol = userFileReading(sevastopol);

    createOutputFile(sevastopol, argv[2], argv[3], argv[4]);

    clearAVL(sevastopol);

    return 0;
}
