;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;11/3/99 djm Saved two bytes by removing useless ld h,0
;
;
;	$Id: getk.asm,v 1.5 2016-03-04 23:10:03 dom Exp $
;

                INCLUDE "stdio.def"

                PUBLIC    getk    ;Read keys
                PUBLIC    _getk    ;Read keys
                EXTERN     getcmd



.getk
._getk
        ld      bc,0
        call_oz(os_tin)
        ld      hl,0
        ret     c
        and     a
        jp      z,getcmd
        ld      l,a
        ret
