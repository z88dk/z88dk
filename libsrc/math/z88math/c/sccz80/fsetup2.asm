;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;




; Set up the registers for our unary
; Return with main set in

                SECTION  code_fp
                PUBLIC    fsetup2
		EXTERN	fa

.fsetup2
        ld      hl,(fa+1)
	exx
        ld      hl,(fa+3)
        ld      a,(fa+5)
        ld      c,a
        ret
