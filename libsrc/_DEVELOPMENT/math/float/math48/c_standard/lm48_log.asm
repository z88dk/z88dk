
; double log(double x)

SECTION code_fp_math48

PUBLIC lm48_log

EXTERN mm48_ln

   ; compute base-e logarithm of x
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;           AC'(BCDEHL') = ln(x)
   ;           carry reset
   ;
   ;         fail on domain error
   ;
   ;           AC'(BCDEHL') = double_min
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_log = mm48_ln
