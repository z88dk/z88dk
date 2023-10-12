;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double asin(double)
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  atan

        EXTERN  fsetup
        EXTERN  stkequ2

atan:
        call    fsetup
  IF    FORz88
        fpp     (FP_ATN)
  ELSE
        ld      a, +(FP_ATN)
        call    FPP
  ENDIF
        jp      stkequ2



