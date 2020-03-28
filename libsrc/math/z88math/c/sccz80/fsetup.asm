;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm




; Set up the registers for our operation
; Return with main set in

                SECTION  code_fp
                PUBLIC    fsetup
		EXTERN	fa

.fsetup
        ld      ix,4    ;ret to this function and ret to code
        add     ix,sp
        ld      l,(ix+1)
        ld      h,(ix+2)
        ld      de,(fa+1)
        exx                     ;main set
        ld      l,(ix+3)
        ld      h,(ix+4)
        ld      de,(fa+3)
        ld      c,(ix+5)
        ld      a,(fa+5)
        ld      b,a
        ret
