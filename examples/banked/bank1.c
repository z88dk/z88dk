
#include <stdio.h>

#include "banking.h"

#if __SMS__ || __CPC__
#define BANK 5
#pragma bank 5
#else
#define BANK 1
#pragma bank 1
#endif


int func_bank1() {
    printf("Printing from bank%d\n",BANK);
    return func_bank2();
}
