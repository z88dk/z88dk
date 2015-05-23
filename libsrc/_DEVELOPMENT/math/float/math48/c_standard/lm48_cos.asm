
; double cos(double x)

SECTION code_fp_math48

PUBLIC lm48_cos

EXTERN mm48_cos

   ; compute cos(x)
   ;
   ; enter : AC'(BCDEHL') = double x in radians
   ;
   ; exit  : AC'(BCDEHL') = cos(x)
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_cos = mm48_cos
