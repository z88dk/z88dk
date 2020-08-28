// Simple ACIA emulator

#include <stdio.h>
#include "ticks.h"



#define SER_RDRF 0x01
#define SER_TDRE 0x02


int acia_out(int port, int value) {
    if ( (port & 0xff) == 0x80 ) {  // CTRL Register
        return 0;
    } else  if ( (port & 0xff) == 0x81 ) {  // Output
        fputc(value, stdout);
        return 0;
    }
    return -1;
}


int acia_in(int port) {
    if ( (port & 0xff) == 0x80 ) {  // Status
        int have_key = kbhit();
        return (have_key ? SER_RDRF : 0 ) | SER_TDRE;
    } else  if ( (port & 0xff) == 0x81 ) {  // Read data
        return getch();
    }
    return -1;
}