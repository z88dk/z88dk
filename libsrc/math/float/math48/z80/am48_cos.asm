
; double cos(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_cos

EXTERN mm48_cos

   ; compute cos(x)
   ;
   ; enter : AC' = double x in radians
   ;
   ; exit  : AC' = cos(x)
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_cos = mm48_cos
