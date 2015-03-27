
SECTION code_fp_math48

PUBLIC mm48_log

EXTERN mm48_ln, mm48_fpmul, mm48__add10

mm48_log:

;     Ten's logarithm
;     ---------------
;
;     NAME:      LOG
;     FUNCTION:  AC=LOC(AC) or AC=LN(AC)/LN(10). AC is set equal
;                to the ten's logarithm of AC.
;     OFFSET:    1EH
;     OUTPUT:    CF=0: OK.
;                CF=1: AC<=0.
;     STACK:     42 bytes.

;LOG(X) beregnes af LN(X)/LN(10).

   call mm48_ln
   ret c
   exx
   push bc
   push de
   push hl
   ld bc,$5E5B                 ;1/LN(10)
   ld de,$D8A9
   ld hl,$367F
   call mm48_fpmul
   jp mm48__add10
