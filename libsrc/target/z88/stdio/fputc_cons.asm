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
;	$Id: fputc_cons.asm,v 1.9 2016-07-02 13:52:45 dom Exp $
;

                INCLUDE "stdio.def"

		MODULE fputc_cons_native
		SECTION	  code_clib

                PUBLIC    fputc_cons_native	;Print char

.fputc_cons_native
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
IF STANDARDESCAPECHARS
	cp      10
ELSE
        cp      13
ENDIF
        jr      z,putchar1
        call_oz(os_out)		;preserves ix
	ld	l,a
	ld	h,0
        ret
.putchar1
        call_oz(gn_nln)		;preserves ix
IF STANDARDESCAPECHARS
	ld	hl,10
ELSE
	ld	hl,13
ENDIF
	ret

