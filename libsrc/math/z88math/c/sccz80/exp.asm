;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double log10(double)
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  exp

        EXTERN  fsetup
        EXTERN  stkequ2

exp:
        call    fsetup
  IF    FORz88
        fpp     (FP_EXP)
  ELSE
        ld      a, +(FP_EXP)
        call    FPP
  ENDIF
        jp      stkequ2



