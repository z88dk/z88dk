
#include "ticks.h"
#include <stdio.h>

void hook_cpm(void)
{
    if ( c == 0x02 ) {
        fputc(e, stdout);
	    fflush(stdout);
    } else if ( c == 0x09 ) {
        // Print string
        int addr = d << 8 | e;
        int tp;
        while ( ( tp = *get_memory_addr(addr)) ) {
            if ( tp == '$' ) 
                break;
            fputc(tp, stdout);
            addr++;
        }
        fflush(stdout);
    }
}
