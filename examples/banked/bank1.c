
#include <stdio.h>

#include "banking.h"

#pragma bank 1

int func_bank1() {
    printf("Printing from bank1\n");
    return func_bank2();
}
