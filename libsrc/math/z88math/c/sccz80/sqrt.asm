;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double sqrt(double)
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  sqrt

        EXTERN  fsetup
        EXTERN  stkequ2

sqrt:
        call    fsetup
  IF    FORz88
        fpp     (FP_SQR)
  ELSE
        ld      a, +(FP_SQR)
        call    FPP
  ENDIF
        jp      stkequ2



