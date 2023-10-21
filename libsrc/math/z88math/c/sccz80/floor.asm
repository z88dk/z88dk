;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double floor(double)
;Number in FA..

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  floor

        EXTERN  fsetup
        EXTERN  stkequ2

floor:
        call    fsetup
  IF    FORz88
        fpp     (FP_INT)                ;floor it (round down!)
  ELSE
        ld      a, +(FP_INT)
        call    FPP
  ENDIF
        jp      stkequ2



