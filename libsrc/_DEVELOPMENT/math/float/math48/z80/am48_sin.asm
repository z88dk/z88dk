
; double sin(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_sin

EXTERN mm48_sin

   ; compute sin(AC')
   ;
   ; enter : AC' = double x in radians
   ;
   ; exit  : AC' = sin(x)
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_sin = mm48_sin
