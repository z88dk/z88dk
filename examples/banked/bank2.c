


#include <stdio.h>
#include "banking.h"

#pragma bank 2

int func_bank2() {
    // printf is in common code
    printf("Printing from bank2\n");
    return func_bank3(12);
}
