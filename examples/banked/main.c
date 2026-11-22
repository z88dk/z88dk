

#include <stdio.h>
#include <sys/ioctl.h>
#include <features.h>

#include "banking.h"


extern __banked int banked_val;

int main() {
    int val;
#ifdef __SMS__
    val = 2;
    console_ioctl(IOCTL_GENCON_SET_MODE,&val);
#endif
    printf("Printing from main memory bank\n");
    val = func_bank1();
    printf("Returned value from bank calls is %d\n",val);
#ifdef __HAVE_BANKED_FAR_MAPPING
    printf("Bank 4 value is %d\n",banked_val);
#endif
    while(1) {}
}
