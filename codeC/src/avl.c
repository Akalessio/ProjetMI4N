#include <stdio.h>
#include <stdlib.h>
#include "avl.h"
#include "fonx.h"

//build an AVL node which is called station
Station *buildStation(int id, long long capacity){
    Station *a = malloc(sizeof(Station));
    if(a == NULL){
        exit(1);
    }
    a->id = id;
    a->capacity = capacity;
    a->left = NULL;
    a->right = NULL;
    a->height = 1;
    a->totalLoad = 0;

    return a;
}

//update the height of a station
void updateHeight(Station *a){
    if(a->right != NULL && a->left != NULL) {
        a->height = maxInt(a->left->height, a->right->height) + 1;
    }else if(a->right != NULL && a->left == NULL){
        a->height = a->right->height + 1;
    }else if(a->right == NULL && a->left != NULL){
        a->height = a->left->height + 1;
    }else if(a->right == NULL && a->left == NULL){
        a->height = 1;
    }
}

//left rotating the AVL tree 
Station *rotateLeft(Station *a){
    Station *pivot;

    pivot = a->right;
    a->right = pivot->left;
    pivot->left = a;

    updateHeight(a);
    updateHeight(pivot);

    return pivot;
}

//right rotating the AVL tree 
Station *rotateRight(Station *a){
    Station *pivot;

    pivot = a->left;
    a->left = pivot->right;
    pivot->right = a;

    updateHeight(a);
    updateHeight(pivot);

    return pivot;
}

//insert a station in the tree and balance the tree
Station *insertStationAVL(Station *a, int id, long long capacity){
    int balance = 0;



    if(a == NULL){
        return buildStation(id , capacity);
    }
    if(id < a->id){
        a->left = insertStationAVL(a->left, id, capacity);
    }
    if(id > a->id){
        a->right = insertStationAVL(a->right, id, capacity);
    }
    if(id == a->id){
        return a;
    }


    updateHeight(a);

    if(a->right != NULL && a->left != NULL) {
        balance = a->right->height - a->left->height;
    }else if(a->right != NULL && a->left == NULL){
        balance = a->right->height;
    }else if(a->right == NULL && a->left != NULL){
        balance = - a->left->height;
    }else if(a->right == NULL && a->left == NULL){
        balance = 0;
    }

    if(balance > 1 && id > a->right->id){
        a = rotateLeft(a);
    }if(balance < -1 && id < a->left->id){
        a = rotateRight(a);
    }if(balance > 1 && id < a->right->id){
        a->right = rotateRight(a->right);
        a = rotateLeft(a);
    }if(balance < -1 && id > a->left->id){
        a->left = rotateLeft(a->left);
        a = rotateRight(a);
    }

    return a;
}

//add the load of an user to a station
void addLoadStation(Station *a, int id, long long load){
    if(a == NULL){
        return;
    }

    if (id < a->id){
        addLoadStation(a->left, id, load);
    }else if(id > a->id){
        addLoadStation(a->right, id, load);
    }else if(id == a->id){
        a->totalLoad += load;
    }
}

//process the total load of a tree
void totalLoadSum(Station *a, long long *sumL, long long *sumC){
    if(a == NULL){
        return;
    }
    *sumL += a->totalLoad;
    *sumC += a->capacity;
    totalLoadSum(a->left, sumL, sumC);
    totalLoadSum(a->right, sumL, sumC);
}

//count the number of station on the tree
void stationCount(Station *a, int *count){
    if(a == NULL){
        return;
    }
    (*count)++;
    stationCount(a->left, count);
    stationCount(a->right,count);
}

//calculate the yield of each station
double stationYield(long long totalCapacity, long long totalLoad){
    double a = (double)totalLoad / totalCapacity;
    a = a*100;
    return a;
}

//print the tree
void printInOrder(Station *a) {
    if (a == NULL) return;
    printInOrder(a->left);
    printf("Station ID: %d, Capacity: %lld, Load: %lld, Yield: %lf\n", a->id, a->capacity, a->totalLoad, stationYield(a->capacity, a->totalLoad));
    printInOrder(a->right);
}

//free the tree
void clearAVL(Station *a){
    if(a == NULL){
        return;
    }
    clearAVL(a->left);
    clearAVL(a->right);
    free(a);
}

