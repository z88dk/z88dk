
; double trunc(double x)

SECTION code_fp_math48

PUBLIC lm48_trunc

EXTERN mm48_int

   ; compute trunc(x)
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : AC'(BCDEHL') = trunc(x)
   ;
   ; notes : trunc(3.7)  =  3
   ;         trunc(-3.7) = -3
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_trunc = mm48_int
