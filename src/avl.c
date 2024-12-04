#include <stdio.h>
#include <stdlib.h>
#include "avl.h"
#include "fonx.h"

Station *buildStation(int id, long long capacity){
    Station *a = malloc(sizeof(Station));

    a->id = id;
    a->capacity = capacity;
    a->left = NULL;
    a->right = NULL;
    a->heigt = 1;
    a->totalLoad = 0;

    return a;
}
void updateHeight(Station *a){
    if(a->right != NULL && a->left != NULL) {
        a->heigt = maxInt(a->left->heigt, a->right->heigt) + 1;
    }else if(a->right != NULL && a->left == NULL){
        a->heigt = a->right->heigt + 1;
    }else if(a->right == NULL && a->left != NULL){
        a->heigt = a->left->heigt + 1;
    }else if(a->right == NULL && a->left == NULL){
        a->heigt = 1;
    }
}

Station *rotateLeft(Station *a){
    Station *pivot;

    pivot = a->right;
    a->right = pivot->left;
    pivot->left = a;

    updateHeight(a);
    updateHeight(pivot);

    return pivot;
}

Station *rotateRight(Station *a){
    Station *pivot;

    pivot = a->left;
    a->left = pivot->right;
    pivot->right = a;

    updateHeight(a);
    updateHeight(pivot);

    return pivot;
}

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
        balance = a->right->heigt - a->left->heigt;
    }else if(a->right != NULL && a->left == NULL){
        balance = a->right->heigt;
    }else if(a->right == NULL && a->left != NULL){
        balance = - a->left->heigt;
    }else if(a->right == NULL && a->left == NULL){
        balance = 0;
    }

    if(balance > 1 && id > a->right->id){
        a = rotateLeft(a);
    }
    if(balance < 1 && id < a->left->id){
        a = rotateRight(a);
    }
    if(balance > 1 && id < a->right->id){
        a->right = rotateRight(a->right);
        a = rotateLeft(a);
    }
    if(balance < 1 && id > a->right->id){
        a->left = rotateLeft(a->left);
        a = rotateRight(a);
    }
    return a;
}

