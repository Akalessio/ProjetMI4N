#ifndef PROJETMI4N_AVL_H
#define PROJETMI4N_AVL_H

//struct for the avl tree
typedef struct station{
    int id;
    long long capacity;
    long long totalLoad;
    int height;
    struct station *left;
    struct station *right;
}Station;

Station *buildStation(int, long long);

void updateHeight(Station *);

Station *rotateLeft(Station *);

Station *rotateRight(Station *);

Station *insertStationAVL(Station *, int , long long );

void addLoadStation(Station *, int , long long);

void totalLoadSum(Station *, long long *, long long*);

void stationCount(Station *, int *);

double stationYield(long long, long long );

void printInOrder(Station *);

void clearAVL(Station *a);

#endif
