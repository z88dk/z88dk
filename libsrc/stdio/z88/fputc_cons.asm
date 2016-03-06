;
;       Small C+ Library Functions
;
;	Renamed once more and rechristened for ANSIstdio
;
;	This outputs a character to the console
;
;	1/4/2000 (Original Aug 98)
;
;
;
;	$Id: fputc_cons.asm,v 1.6 2016-03-06 21:36:52 dom Exp $
;

                INCLUDE "stdio.def"

		SECTION	  code_clib

                PUBLIC    fputc_cons	;Print char
                PUBLIC    _fputc_cons	;Print char

.fputc_cons
._fputc_cons
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        cp      13
        jr      z,putchar1
        call_oz(os_out)		;preserves ix
	ld	l,a
	ld	h,0
        ret
.putchar1
        call_oz(gn_nln)		;preserves ix
	ld	hl,13
	ret

