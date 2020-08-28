

#include "ticks.h"
#include <stdio.h>



void hook_rc2014(void) {
    if ( pc == 0x08 + 2 ) {
        fputc(a, stdout);
    } else if ( pc == 0x10 + 2 ) {
        a = getch();
        if ( a == 10 ) a = 13; // Return key sorting
        else if ( a == 127 ) a = 8;
    } else if ( pc == 0x18 + 2 ) {
        int v = kbhit();
        a = v ? 1 : 0;
    } 
}