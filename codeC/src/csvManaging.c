#include "csvManaging.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "avl.h"
#include "fonx.h"

//read the file and create each station in the outuputstation.csv file
Station *stationFileReading(){
    FILE *file = fopen("../tmp/outputstation.csv", "r+");

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

//read the file and add the load ot each station based on the outputuser.csv file
Station *userFileReading(Station *sevastopol){
    FILE *file = fopen("../tmp/outputuser.csv", "r+");

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

//print the tree in the main output file
void printInFile(Station *a, FILE *filename) {
    if (a == NULL) return;
    printInFile(a->left, filename);
    fprintf(filename, "%d:%lld:%lld\n", a->id, a->capacity, a->totalLoad);
    printInFile(a->right, filename);
}

//print the tree in the csv output file but with the factor so it can be processed in a minmax file (lv all case)
void printInFileLVALL(Station *a, FILE *filename) {
    if (a == NULL) return;
    printInFileLVALL(a->left, filename);
    long long absol = a->capacity - a->totalLoad;
    if(absol < 0){
        absol = -absol;
    }
    fprintf(filename, "%d:%lld:%lld:%lld\n", a->id, a->capacity, a->totalLoad, absol);
    printInFileLVALL(a->right, filename);
}

//create the output file
void createOutputFile(Station *sevastopol, char *type, char *user, char *plantID){
    char filename[30] = "";
    type = &type[2];
    user = &user[2];
    strcat(filename, type);
    strcat(filename, "_");
    strcat(filename, user);
    if (plantID != NULL){
        strcat(filename, "_");
        strcat(filename, plantID);
    }
    strcat(filename, ".csv");


    FILE *outputProcessedStationFile = fopen(filename, "w+");
    fileCheck(outputProcessedStationFile);

    if(strcmp(type, "lv") == 0 && strcmp(user, "all") == 0){
        fprintf(outputProcessedStationFile, "#ID_%s:Capacity:Load_%s:factor\n", type, user);
        printInFileLVALL(sevastopol, outputProcessedStationFile);
    }else{
        fprintf(outputProcessedStationFile, "#ID_%s:Capacity:Load_%s\n", type, user);
        printInFile(sevastopol, outputProcessedStationFile);
    }
    fclose(outputProcessedStationFile);
}
