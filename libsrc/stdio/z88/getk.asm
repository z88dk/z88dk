;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;11/3/99 djm Saved two bytes by removing useless ld h,0
;
;
;	$Id: getk.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;

                INCLUDE "stdio.def"

                XLIB    getk    ;Read keys
                LIB     getcmd



.getk
        ld      bc,0
        call_oz(os_tin)
        ld      hl,0
        ret     c
        and     a
        jp      z,getcmd
        ld      l,a
        ret
