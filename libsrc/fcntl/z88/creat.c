/*
 *      Part of the library for fcntlt
 *
 *      int creat(char *name,mode_t mode)
 *
 *      djm 27/4/99
 *
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int creat(far char *name, mode_t mode)
{
#asm
        INCLUDE "#fileio.def"
        
        ld      ix,0
        add     ix,sp
        ld      e,(ix+4)        ;lower 16 of filename
        ld      d,(ix+5)
        ld      b,(ix+6)        ;bank for filename
        ld      a,2             ;write starts from the start?!?!?
        ld      hl,-10
        add     hl,sp
        ld      sp,hl
        ex      de,hl           ;swap where to expand and filename over
        ld      c,10            ;maximum length of expanded filename
        call_oz(gn_opf)
        ex      af,af
        ld      hl,10
        add     hl,sp
        ld      sp,hl           ;restore our stack (we did nothing to it!)
        ex      af,af
        ld      hl,-1
        ret     c               ;open error
        push    ix              ;get filedescriptor in ix into hl
        pop     hl
#endasm
}

