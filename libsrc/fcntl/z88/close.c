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
 * $Id: close.c,v 1.3 2013-03-03 23:51:10 pauloscustodio Exp $
 */


#include <fcntl.h>


int close(int fd)
{
#asm
        INCLUDE         "fileio.def"
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
