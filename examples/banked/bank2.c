


#include <stdio.h>
#include "banking.h"

#ifdef __SPECTRUM
#pragma bank 4
#else
#pragma bank 2
#endif

int func_bank2() {
    // printf is in common code
    printf("Printing from bank2\n");
    return func_bank3(12);
}
