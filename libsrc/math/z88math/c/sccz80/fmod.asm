;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm



;
;       fmod(z,x) = z-x*floor(z/x)
;               if x>0 then  0 <= fmod(z,x) < x
;               if x<0 then  x < fmod(z,x) <= 0
;
;x is in the FA
;z is on the stack +8 (+2=x)

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  fmod

        EXTERN  fsetup
        EXTERN  stkequ2
        EXTERN  fa

fmod:
        ld      ix, 8
        add     ix, sp
        ld      l, (ix+1)
        ld      h, (ix+2)
        ld      de, (fa+1)
        exx                             ;main set
        ld      c, (ix+5)
        ld      l, (ix+3)
        ld      h, (ix+4)
        ld      de, (fa+3)
        ld      a, (fa+5)
        ld      b, a
        push    ix
  IF    FORz88
        fpp     (FP_DIV)
  ELSE
        ld      a, +(FP_DIV)
        call    FPP
  ENDIF
  IF    FORz88
        fpp     (FP_INT)                ;floor
  ELSE
        ld      a, +(FP_INT)
        call    FPP
  ENDIF
;Load up x from the FA and multiply
        ld      de, (fa+3)
        ld      a, (fa+5)
        ld      b, a
        exx
        ld      de, (fa+1)
        exx
  IF    FORz88
        fpp     (FP_MUL)
  ELSE
        ld      a, +(FP_MUL)
        call    FPP
  ENDIF
  IF    FORz88
        fpp     (FP_NEG)                ;negate
  ELSE
        ld      a, +(FP_NEG)
        call    FPP
  ENDIF
;load up z again
        pop     ix
        ld      e, (ix+3)
        ld      d, (ix+4)
        ld      b, (ix+5)               ;exponent
        exx
        ld      e, (ix+1)
        ld      d, (ix+2)
        exx
  IF    FORz88
        fpp     (FP_ADD)
  ELSE
        ld      a, +(FP_ADD)
        call    FPP
  ENDIF
        jp      stkequ2

