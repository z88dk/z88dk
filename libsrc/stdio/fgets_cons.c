/*
 *	Spectrum C library
 *
 *	23/1/2000 djm
 *	24/1/2003 minor fixes by chriscowley
 *
 *	This is as usual my slightly non standard gets()
 *	which takes a length argument..
 *
 * --------
 * $Id: fgets_cons.c,v 1.10 2016-04-23 08:21:02 dom Exp $
 */

#include <stdio.h>
#include <ctype.h>

extern unsigned char _cons_state;

// Pick up the delete key as defined by the crt
extern void *_CRT_KEY_DEL;
#define KEY_DEL &_CRT_KEY_DEL
extern void *_CRT_KEY_CAPS_LOCK;
#define KEY_CAPS_LOCK &_CRT_KEY_CAPS_LOCK

// The soft cursor needs to be disabled for some firmwares
extern void *_CLIB_DISABLE_FGETS_CURSOR;
#define CLIB_DISABLE_FGETS_CURSOR &_CLIB_DISABLE_FGETS_CURSOR

extern void fgets_cons_erase_character(unsigned char toerase) __z88dk_fastcall;

static void docursor(void);

char *fgets_cons(char *str, size_t max)
{
    int c;
    int ptr;

    ptr = 0;

    docursor();
    while (ptr < max - 1) {
        c = fgetc_cons();

        if (c == KEY_CAPS_LOCK)
        {
            _cons_state ^= 1; // Toggle caps lock

        } else if ( c == KEY_DEL)
        {
            if ( ptr > 0 )
            {
                if ( CLIB_DISABLE_FGETS_CURSOR == 0 ) {
                    fgets_cons_erase_character('_');
                }
                fgets_cons_erase_character(str[--ptr]);
                str[ptr] = 0;
                docursor();
            }

        } else if (c == 4 || c == -1)
        {
            break;

        } else
        {
            if (_cons_state)
                c = toupper(c);

            str[ptr] = c;
            str[++ptr] = 0;
            if ( CLIB_DISABLE_FGETS_CURSOR == 0 ) {
                fgets_cons_erase_character('_');
            }
            fputc_cons(c);
            if (c == '\n' || c == '\r')
                break;
            docursor();
        }
    }
    return ptr ? str : NULL;
}

static void docursor(void) {
    if ( CLIB_DISABLE_FGETS_CURSOR == 0 ) {
        fputc_cons('_');
    }
}
