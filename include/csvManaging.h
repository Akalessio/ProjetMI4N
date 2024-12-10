#ifndef PROJETMI4N_CSVMANAGING_H
#define PROJETMI4N_CSVMANAGING_H

#include "avl.h"
#include <stdio.h>

Station *stationFileReading(void);

Station *userFileReading(Station *);

void printInFile(Station *, FILE *);

void printInFileLVALL(Station *, FILE *);

void createOutputFile(Station *, char *, char *, char *);

#endif
