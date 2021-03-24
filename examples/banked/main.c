

#include <stdio.h>
#include <sys/ioctl.h>

#include "banking.h"


int main() {
    int val;
#ifdef __SMS__
    val = 2;
    console_ioctl(IOCTL_GENCON_SET_MODE,&val);
#endif
    printf("Printing from main memory bank\n");
    val = func_bank1();
    printf("Returned value from bank calls is %d\n",val);
    while( 1 ) { }
}
