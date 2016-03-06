/*
 *      Part of the library for fcntlt
 *
 *      size_t read(int fd,void *ptr, size_t len)
 *
 *      djm 27/4/99
 *
 *      Close a file descriptor, pretty well identical to
 *      fclose from the other stuff
 *
 * -----
 * $Id: read.c,v 1.4 2016-03-06 20:36:13 dom Exp $
 */


#include <sys/types.h>
#include <fcntl.h>


size_t read(int fd, void *ptr, size_t len)
{
#asm
        INCLUDE         "fileio.def"
        push    ix
        ld      ix,4
        add     ix,sp
        ld      c,(ix+0)        ;len
        ld      b,(ix+1)
        ld      e,(ix+2)        ;ptr
        ld      d,(ix+3)
        ld      l,(ix+4)        ;fd
        ld      h,(ix+5)
        push    hl
        pop     ix
        push    bc
        ld      hl,0            ;move from file to memory (hl=0, de=addr)
        call_oz(os_mv)          ;exits with bc=bytes not read
        pop     hl
        and     a
        sbc     hl,bc
        pop     ix
#endasm
}
