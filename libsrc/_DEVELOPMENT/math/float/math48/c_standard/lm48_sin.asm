
; double sin(double x)

SECTION code_fp_math48

PUBLIC lm48_sin

EXTERN mm48_sin

   ; computes sin(x)
   ;
   ; enter : AC'(BCDEHL') = double x in radians
   ;
   ; exit  : AC'= sin(x)
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_sin = mm48_sin
