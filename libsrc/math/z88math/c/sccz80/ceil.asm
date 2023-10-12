;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double ceil(double)
;Number in FA..
;
;This is implemented as  -(floor(-x))

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  ceil

        EXTERN  fsetup
        EXTERN  stkequ2

ceil:
        call    fsetup
  IF    FORz88
        fpp     (FP_NEG)
  ELSE
        ld      a, +(FP_NEG)
        call    FPP
  ENDIF
  IF    FORz88
        fpp     (FP_INT)                ;floor it (round down!)
  ELSE
        ld      a, +(FP_INT)
        call    FPP
  ENDIF
  IF    FORz88
        fpp     (FP_NEG)
  ELSE
        ld      a, +(FP_NEG)
        call    FPP
  ENDIF
        jp      stkequ2



