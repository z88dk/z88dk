;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm



;Convert fp in FA to an integer

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  ifix
        EXTERN  fa

ifix:
        ld      hl, (fa+1)
        exx
        ld      hl, (fa+3)
        ld      a, (fa+5)
        ld      c, a
  IF    FORz88
        fpp     (FP_FIX)
  ELSE
        ld      a, +(FP_FIX)
        call    FPP
  ENDIF
        push    hl                      ;msb
        exx
        pop     de                      ;stick msb in de so we can convert to longs if needed
        ret
