

#include <stdio.h>
#include "banking.h"

#pragma bank 3

int func_bank3(int value) {
    // printf is in common code
    printf("Printing from bank3 - passed value %d\n",value);
    return 0x55;
}
