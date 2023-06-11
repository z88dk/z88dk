


#include <stdio.h>
#include "banking.h"

#if __SPECTRUM
#define BANK 4
#pragma bank 4
#elif __CPC__
#define BANK 6
#pragma bank 6
#else
#define BANK 2
#pragma bank 2
#endif


int func_bank2() {
    // printf is in common code
    printf("Printing from bank%d\n",BANK);
    return func_bank3(12);
}
