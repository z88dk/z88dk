/*
 *      Part of the library for fcntlt
 *
 *      long lseek(int fd,long posn, int whence)
 *
 *      djm 27/4/99
 *
 *      whence=
 *
 *   0  SEEK_SET from start of file
 *   1  SEEK_CUR from current position
 *   2  SEEK_END from end of file (always -ve)
 *
 * -----
 * $Id: lseek.c,v 1.5 2016-03-06 20:36:12 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

long lseek(int fd, long posn, int whence)
{
#asm
        INCLUDE "fileio.def"
        push	ix		;save callers 
        ld      ix,2    
        add     ix,sp
        ld      a,(ix+2)        ;whence
        ld      e,(ix+8)
        ld      d,(ix+9)        ;fd
        and     a
        jp      nz,l_offset
; SEEK_SET, set from start of file
        ld      hl,4
        add     hl,sp           ;points to posn(vector)
        push    de
        pop     ix
        ld      a,FA_PTR
        call_oz(os_fwm)
.l_exit
        ld      hl,-1           ;load hlde with -1L
        ld      de,-1
        jr	c,l_exit_final               ;error
; Get the position of the file, use frm to do it
        ld      a,FA_PTR
        call_oz(os_frm)         ;must succeed if we get this far!
        ld      l,c             ;hl=bc
        ld      h,b
l_exit_final:
	pop	ix		;restore callers ix
        ret


.l_offset
        cp      2               ;check to see if in range
        ccf
        jr      c,l_exit
; SEEK_CUR, SEEK_END set from current position
; Rather conveniently the values wanted by OZ coincide with UNIX
; values! So just leave a as it is!
;
; - Read the current file positon/eof position
; - Add the value to the one we want
; - Set file position
; - jp l_exit
        call_oz(os_frm)
.l_offsetcont
        jr      c,l_exit        ;exit with -1
        ld      l,c
        ld      h,b
        exx                     ;keep debc safe
        ld      hl,7            ;pick up required position
        add     hl,sp
        ld      d,(hl)
        dec     hl
        ld      e,(hl)
        dec     hl
        ld      a,(hl)
        dec     hl
        ld      l,(hl)
        ld      h,a
        push    de              ;push (requirement of l_long_add)
        push    hl
        exx
        call    l_long_add      ;dehl=new position
        push    de
        push    hl
        ld      hl,0
        add     hl,sp
        ld      a,FA_PTR
        call_oz(os_fwm)
        pop     bc              ;discard stored length
        pop     bc
        jr      l_exit

#endasm
}

