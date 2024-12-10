#include "csvManaging.h"
#include <stdio.h>
#include <stdlib.h>
#include "avl.h"
#include "fonx.h"

Station *stationFileReading(){
    FILE *file = fopen("tmp/outputstation.csv", "r+");

    fileCheck(file);

    char line[100];
    int id;
    long long capacity;

    fgets(line, sizeof(line), file);

    Station *sevastopol = NULL;

    while (fscanf(file, "%d;%*[^;];%*[^;];%*[^;];%*[^;];%*[^;];%lld;%*s", &id, &capacity) == 2){
        sevastopol = insertStationAVL(sevastopol, id, capacity);
    }

    fclose(file);
    return sevastopol;
}

Station *userFileReading(Station *sevastopol){
    FILE *file = fopen("tmp/outputuser.csv", "r+");

    fileCheck(file);

    char line[100];
    int id;
    long long load;

    fgets(line, sizeof(line), file);

    while (fscanf(file, "%d;%*[^;];%*[^;];%*[^;];%*[^;];%*[^;];%*[^;];%lld", &id, &load) == 2){
        addLoadStation(sevastopol, id, load);
    }

    fclose(file);
    return sevastopol;
}
