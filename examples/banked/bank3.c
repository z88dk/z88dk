

#include <stdio.h>
#include "banking.h"

#if __CPC__
#define BANK 7
#pragma bank 7
#else
#define BANK 3
#pragma bank 3
#endif


int func_bank3(int value) {
    // printf is in common code
    printf("Printing from bank%d - passed value %d\n",BANK,value);
    return 0x55;
}
