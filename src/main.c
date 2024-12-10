#include <stdio.h>
#include <stdlib.h>
#include "avl.h"
#include "fonx.h"
#include "csvManaging.h"


int main(int argc, char **argv) {
    printf("HELLO\n");
    printf("%s\n%s\n%s\n%s\n\n", argv[1], argv[2], argv[3], argv[4]);

    Station *sevastopol = stationFileReading();

    int stationNumber = 0;
    stationCount(sevastopol, &stationNumber);

    printf("there are %d %s station\n\n", stationNumber, argv[2]);

    sevastopol = userFileReading(sevastopol);

    long long stationsLoad = 0;
    long long stationsCapacity = 0;
    totalLoadSum(sevastopol, &stationsLoad, &stationsCapacity);

    printf("the total load of all the %s station is %lld kWh\n", argv[2], stationsLoad);
    printf("the total capacity of all the %s station is %lld kWh\n", argv[2], stationsCapacity);
    printf("the total yield of all the %s station is %lf kWh\n", argv[2], stationYield(stationsCapacity, stationsLoad));

    printInOrder(sevastopol);

    clearAVL(sevastopol);

    return 0;
}
