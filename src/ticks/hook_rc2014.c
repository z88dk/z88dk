
#include "ticks.h"
#include <stdio.h>
#ifndef WIN32
#include <unistd.h>
#else
#include <io.h>     /* isatty() */
#include <conio.h>  /* getch() / kbhit() */
#endif



void hook_rc2014(void) {
    if ( pc == 0x08 + 2 ) {
        fputc(a, stdout);
        fflush(stdout);
    } else if ( pc == 0x10 + 2 ) {
        int val;
        /* Match cmd_readkey: on a non-tty, always use getchar() so
         * printf ... | z88dk-ticks suite input works.  MinGW (msys2 CI)
         * defines WIN32 and used to call getch() unconditionally, which
         * reads the console and ignores the pipe — hanging forever at
         * test_scanf_serial until the job 6h timeout.  Cygwin is not
         * WIN32 and already used the isatty path. */
        if ( isatty(fileno(stdin)) )
            val = getch();
        else
            val = getchar();
        a = val;
        if ( a == 10 ) a = 13; // Return key sorting
        else if ( a == 127 ) a = 8;
    } else if ( pc == 0x18 + 2 ) {
        int v = kbhit();
        a = v ? 1 : 0;
    } 
}
