#ifndef PROJETMI4N_AVL_H
#define PROJETMI4N_AVL_H

typedef struct station{
    int id;
    long long capacity;
    long long totalLoad;
    int heigt;
    struct station *left;
    struct station *right;
}Station;


#endif
