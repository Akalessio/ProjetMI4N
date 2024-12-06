#include <stdio.h>
#include <stdlib.h>
#include "avl.h"


int main() {
    // Root of the AVL tree
    Station *root = NULL;

    // Insert test cases
    root = insertStationAVL(root, 7, 5000);  // Inserting root node
    root = insertStationAVL(root, 9, 6000);  // Insert node
    root = insertStationAVL(root, 13, 7000);  // Insert node
    root = insertStationAVL(root, 5, 3000);   // Insert node
    root = insertStationAVL(root, 11, 8000);  // Insert node (triggers balancing)

    printf("Tree after insertion:\n");
    printInOrder(root);

    // Add load to a specific station
    addLoadStation(root, 7, 1000);
    addLoadStation(root, 30, 2000);

    printf("\nTree after adding loads:\n");
    printInOrder(root);

    // Compute total load sum
    long long totalSum = 0;
    totalLoadSum(root, &totalSum);
    printf("\nTotal Load Sum: %lld\n", totalSum);

    // Compute station count
    int count = 0;
    stationCount(root, &count);
    printf("Total Station Count: %d\n", count);

    // Compute yield
    double yield = stationYield(3002, totalSum);  // Assuming total capacity is 30000
    printf("Station Yield: %.2f%%\n", yield);

    // Free the AVL tree
    clearAVL(root);
    root = NULL;

    return 0;
}
