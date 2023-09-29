
#include "ticks.h"
#include <stdio.h>
#ifndef WIN32
#include <unistd.h>                         // For declarations of isatty()
#else
#include <conio.h>
#include <io.h>
#endif

static int user_num = 0;

void hook_cpm(void)
{
    switch (c) {
    case 0x01:  // C_READ
        /* Entered with C=1. Returns A=L=character.
           Wait for a character from the keyboard; then echo it to the screen and return it. */
       a = l = fgetc(stdin);
       break;
    case 0x02:  // C_WRITE
        /* Entered with C=2, E=ASCII character. */
        if ( e != 12 ) {
            fputc(e, stdout);
            fflush(stdout);
        }
        break;
    case 0x06:  // C_RAWIO
        /* E=0FF Return a character without echoing if one is waiting; zero if none is available. */
        if ( e == 0xff ) {
            int val;
            if (isatty(fileno(stdin)))
                val = getch();          // read one character at a time if connected to a tty
            else
                val = getchar();        // read in cooked mode if redirected from a file
            if ( val == EOF ) val = 0;
            else if ( val == 10 ) val = 13;
            else if ( val == 13 ) val = 10;
            a = l = val;
        }
        break;
    case 0x09:  // C_WRITESTR
        /* Entered with C=9, DE=address of string terminated by $ */
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
        }
        break;
    case 0x0b:  // C_STAT
        /* Entered with C=0Bh. Returns A=L=status.
           Returns A=0 if no characters are waiting, nonzero if a character is waiting. */
        {
            int val;
            if ( (val = kbhit()) == EOF )
                val = 0;
            a = l = val;
        }
        break;
    case 0x0c:  // S_BDOSVER
        /* Entered with C=0Ch. Returns B=H=system type, A=L=version number. */
        b = h = 0;
        a = l = 0x22;
        break;
    case 0x0e:  // DRV_SET
        /* Entered with C=0Eh, E=drive number. Returns L=A=0 or 0FFh. */
        if ( e == 0 )
            a = l = 0;  // Current drive is a
        else
            a = l = 0xff; // Selecting an unavailable drive.
        break;
    case 0x19:  // DRV_GET
        /* Entered with C=19h, E=drive number. Returns L=A=0 or 0FFh. */
        if ( e == 0 )
            a = l = 0;  // Current drive is a
        else
            a = l = 0xff; // Selecting an unavailable drive.
        break;
    case 0x20:  // F_USERNUM
        /* Entered with C=20h, E=number. If E=0FFh, returns number in A. */
        if ( e == 0xff )
            a = l = user_num;
        else
            if ( e >= 0 && e < 16 )
                user_num = e;
        break;
    default:
        fprintf(stderr,"Unsupported BDOS call %d\n",c);
        break;
    }
}
