

#include <stdio.h>

#include "banking.h"


int main() {
    int val;
    printf("Printing from main memory bank\n");
    val = func_bank1();
    printf("Returned value from bank calls is %d\n",val);
}
