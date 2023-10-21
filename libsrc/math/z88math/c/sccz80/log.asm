;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double log(double)     - natural log
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  log

        EXTERN  fsetup
        EXTERN  stkequ2

log:
        call    fsetup
  IF    FORz88
        fpp     (FP_LN)
  ELSE
        ld      a, +(FP_LN)
        call    FPP
  ENDIF
        jp      stkequ2



