/*
 *      Part of the library for fcntlt
 *
 *      int close(int fd)
 *
 *      djm 27/4/99
 *
 *      Close a file descriptor, pretty well identical to
 *      fclose from the other stuff
 *
 * -----
 * $Id: close.c,v 1.2 2001-04-18 14:59:40 stefano Exp $
 */


#include <fcntl.h>


int close(int fd)
{
#asm
        INCLUDE         "#fileio.def"
        pop     bc
        pop     hl
        push    hl
        push    bc
        ld      a,h
        or      l
        jr      nz,l_close1
.l_close0
        ld      hl,-1
        ret
.l_close1
        push    hl
        pop     ix
        call_oz(gn_cl)
        jr      c,l_close0
        ld      hl,0
#endasm
}
