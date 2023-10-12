;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;minusfa(double)  (internal function, negate number in FA)
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  minusfa

        EXTERN  fsetup2
        EXTERN  stkequ2

minusfa:
        call    fsetup2
  IF    FORz88
        fpp     (FP_NEG)
  ELSE
        ld      a, +(FP_NEG)
        call    FPP
  ENDIF
        jp      stkequ2



