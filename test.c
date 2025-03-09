#include <stdio.h>

/*
    Expected Output:
    Store Detected
    Store Detected
    Load Detected
    Store Detected
    Load Detected
*/ 

// test program
int main() {

    // store
    int x = 10;
    // store & load
    int y = x + 5;

    // store & load
    printf("Result: %d\n", y);
    return 0;
}
