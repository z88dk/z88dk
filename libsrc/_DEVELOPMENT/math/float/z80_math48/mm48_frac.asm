
SECTION code_fp_math48

PUBLIC mm48_frac

EXTERN mm48_equal, mm48_int, mm48_fpsub, mm48__add10

mm48_frac:

;     Fractional part
;     ----------------
;
;     NAME:      FRAC
;     FUNCTION:  AC=FRAC(AC) or AC=AC-INT(AC). AC is set equal to
;                the decimal part of AC with the same sign as AC.
;     OFFSET:    33H
;     STACK:     20 bytes.
;     EXAMPLE:   FRAC(3.7)=0.7
;                FRAC(-3.7)=-0.7

   exx
   push bc
   push de
   push hl
   exx

   call mm48_equal
   exx
   call mm48_int
   exx
   call mm48_fpsub
   jp mm48__add10
