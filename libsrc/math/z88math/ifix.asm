;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm



;Convert fp in FA to an integer 

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    ifix
		EXTERN	fa

.ifix
        ld      hl,(fa+1)
        exx
        ld      hl,(fa+3)
        ld      a,(fa+5)
        ld      c,a
        fpp(FP_FIX)
        push    hl      ;msb
        exx
        pop     de      ;stick msb in de so we can convert to longs if needed
        ret
