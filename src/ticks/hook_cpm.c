
#include "ticks.h"
#include <stdio.h>
#ifndef WIN32
#include <unistd.h>                         // For declarations of isatty()
#else
#include <conio.h>
#include <io.h>
#endif

void hook_cpm(void)
{
    switch (c) {
    case 0x01: // c_read
        /*   Returns A=L=character.
            Wait for a character from the keyboard; then echo it to the screen and return it.
        */
       a=l=fgetc(stdin);
       break;
    case 0x02: // c_write
        // E = ascii character
        if ( e != 12 ) {
            fputc(e, stdout);
            fflush(stdout);
        }
        break;
    case 0x06:  // C_RAWIO
        // E=0FF Return a character without echoing if one is waiting; zero if none is available.
        if ( e == 0xff ) {
            int val;
            if (isatty(fileno(stdin)))
                val = getch();          // read one character at a time if connected to a tty
            else
                val = getchar();        // read in cooked mode if redirected from a file
            if ( val == -1 ) val = 0;
            else if ( val == 10 ) val = 13;
            else if ( val == 13) val  = 10;
            a = val;
        }
        break;
    case 0x09: // c_writestr de=string terminated by $
    {
        int addr = d << 8 | e;
        int tp;
        while ( ( tp = *get_memory_addr(addr)) ) {
            if ( tp == '$' ) 
                break;
            fputc(tp, stdout);
            addr++;
        }
        fflush(stdout);
        break;
    }
    case 0x19:  // DRV_GET
        a = 0;  // Current drive is a
        break;
    default:
        fprintf(stderr,"Unsupported BDOS call %d\n",c);
        break;
    }
}
