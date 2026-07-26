
#include "ticks.h"
#include <stdio.h>
#ifndef WIN32
#include <unistd.h>
#endif



void hook_rc2014(void) {
    if ( pc == 0x08 + 2 ) {
        fputc(a, stdout);
        fflush(stdout);
    } else if ( pc == 0x10 + 2 ) {
        int val;
#ifndef WIN32
        /* Match cmd_readkey: getch() on a non-tty mangles stdin via termios
         * and breaks piped suite input under ticks. */
        if ( isatty(fileno(stdin)) )
            val = getch();
        else
            val = getchar();
#else
        val = getch();
#endif
        a = val;
        if ( a == 10 ) a = 13; // Return key sorting
        else if ( a == 127 ) a = 8;
    } else if ( pc == 0x18 + 2 ) {
        int v = kbhit();
        a = v ? 1 : 0;
    } 
}
