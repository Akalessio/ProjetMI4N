#include "../include/fonx.h"
#include "stdio.h"
#include "stdlib.h"

//return the max between two value
int maxInt(int a, int b){
    if(a>=b){
        return a;
    }else{
        return b;
    }
}

//check if the file is well opened
void fileCheck(FILE *a){
     if(a == NULL){
         exit(10);
     }
}
