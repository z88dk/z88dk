;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;11/3/99 djm Saved two bytes by removing useless ld h,0
;
;
;	$Id: getk.asm,v 1.7 2016-04-29 20:35:11 dom Exp $
;

                INCLUDE "stdio.def"

		SECTION	  code_clib

                PUBLIC    getk    ;Read keys
                PUBLIC    _getk    ;Read keys
                EXTERN     getcmd



.getk
._getk
        ld      bc,0
        call_oz(os_tin)		;preserves ix
        ld      hl,0
        ret     c
        and     a
        jp      z,getcmd
IF STANDARDESCAPECHARS
        cp      13
        jr      nz,not_nln
        ld      a,10
.not_nln
ENDIF
        ld      l,a
        ret
