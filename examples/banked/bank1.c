
#include <stdio.h>

#include "banking.h"

#ifdef __SMS__
#pragma bank 5
#else
#pragma bank 1
#endif

int func_bank1() {
#ifdef __SMS__
    printf("Printing from bank5\n");
#else
    printf("Printing from bank1\n");
#endif
    return func_bank2();
}
