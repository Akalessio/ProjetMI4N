#include "../include/fonx.h"
#include "stdio.h"
#include "stdlib.h"

int maxInt(int a, int b){
    if(a>=b){
        return a;
    }else{
        return b;
    }
}

void fileCheck(FILE *a){
     if(a == NULL){
         exit(10);
     }
}
