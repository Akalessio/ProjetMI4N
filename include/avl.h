#ifndef PROJETMI4N_AVL_H
#define PROJETMI4N_AVL_H

typedef struct station{
    int id;
    long long capacity;
    long long totalLoad;
    int height;
    struct station *left;
    struct station *right;
}Station;


#endif
