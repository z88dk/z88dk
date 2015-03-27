
SECTION code_fp_math48

PUBLIC mm48_tan

EXTERN mm48_equal, mm48_cos, mm48_sin, mm48_fpdiv, mm48__add10

mm48_tan:

;     Tangent
;     -------
;
;     NAME:      TAN
;     FUNCTION:  AC=TAN(AC) eller AC=SIN(AC)/COS(AC). AC is set equal
;                to the tangent of AC.
;     OFFSET:    27H
;     OUTPUT:    CF=0: OK.
;                CF=1: Overflow of the division SIN(AC)/COS(AC), ie.
;                      AC has a value given by AC=PI/2+n*PI, where
;                      n is a whole number.
;     STACK:     12 bytes.

   exx
   push bc
   push de
   push hl
   exx
   call mm48_equal
   call mm48_cos
   exx
   call mm48_sin
   call mm48_fpdiv
   jp mm48__add10
