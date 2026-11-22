
; double trunc(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_trunc

EXTERN mm48_int

   ; compute trunc(x)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = trunc(x)
   ;
   ; notes : trunc(3.7)  =  3
   ;         trunc(-3.7) = -3
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_trunc = mm48_int
