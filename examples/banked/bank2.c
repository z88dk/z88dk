


#include <stdio.h>
#include "banking.h"

#ifdef __SPECTRUM
#pragma bank 4
#else
#pragma bank 2
#endif

int func_bank2() {
    // printf is in common code
#ifdef __SPECTRUM
    printf("Printing from bank4\n");
#else
    printf("Printing from bank2\n");
#endif
    return func_bank3(12);
}
