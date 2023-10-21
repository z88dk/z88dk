;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double cos(double)
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  cos

        EXTERN  fsetup
        EXTERN  stkequ2

cos:
        call    fsetup
  IF    FORz88
        fpp     (FP_COS)
  ELSE
        ld      a, +(FP_COS)
        call    FPP
  ENDIF
        jp      stkequ2



