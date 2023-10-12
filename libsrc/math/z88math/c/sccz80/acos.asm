;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double acos(double)
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  acos

        EXTERN  fsetup
        EXTERN  stkequ2

acos:
        call    fsetup
  IF    FORz88
        fpp     (FP_ACS)
  ELSE
        ld      a, +(FP_ACS)
        call    FPP
  ENDIF
        jp      stkequ2



