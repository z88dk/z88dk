;
;       Small C+ Z88 Internal Routine
;       Puts a string to the console - mapping \n to \n\l as we
;       go and appending \n\l to the end of the line
;
;	Non standard (for short programs)
;
;       djm 2/4/99
;
;
;	$Id: puts_cons.asm,v 1.7 2016-04-29 20:35:11 dom Exp $
;

                INCLUDE "stdio.def"

		SECTION	  code_clib

                PUBLIC    puts_cons
                PUBLIC    _puts_cons


.puts_cons
._puts_cons
	pop	bc
	pop	hl
	push	hl
	push	bc
.putconsole0
        ld      a,(hl)
        and     a
        jr      z,putconsole_out
IF STANDARDESCAPECHARS
	cp	10
ELSE
        cp      13
ENDIF
        jr      z,putconsole_nl
        call_oz(os_out)		;preserves ix
.putconsole_lp
        inc     hl
        jr      putconsole0
.putconsole_out
        call_oz(gn_nln)		;preserves ix
        ret
.putconsole_nl
        call_oz(gn_nln)		;preserves ix
        jr      putconsole_lp
                
