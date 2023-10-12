;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double tan(double)
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  tan

        EXTERN  fsetup
        EXTERN  stkequ2

tan:
        call    fsetup
  IF    FORz88
        fpp     (FP_TAN)
  ELSE
        ld      a, +(FP_TAN)
        call    FPP
  ENDIF
        jp      stkequ2



