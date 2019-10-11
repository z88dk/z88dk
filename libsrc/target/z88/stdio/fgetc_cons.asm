;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;22/3/2000 - This was getkey() renamed to getchar
;
;1/4/2000  - Renamed to fgetc_cons
;
;
;	$Id: fgetc_cons.asm,v 1.8 2016-07-02 13:52:45 dom Exp $
;

                INCLUDE "stdio.def"

		MODULE fgetc_cons
		SECTION	  code_clib

                PUBLIC    fgetc_cons
                PUBLIC    _fgetc_cons
                EXTERN     getcmd  ;process command sequence


.fgetc_cons
._fgetc_cons
.gkloop
        call_oz(os_in)		;preserves ix
        jr      c,gkloop
        and     a
        jp      z,getcmd
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_nln
	ld	a,10
.not_nln
ENDIF
        ld      l,a
        ld      h,0
        ret

