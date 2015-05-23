
; double log10(double x)

SECTION code_fp_math48

PUBLIC lm48_log10

EXTERN mm48_log

   ; compute base-10 log of x
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = log(x)
   ;            carry reset
   ;
   ;         fail if domain error
   ;
   ;            AC'(BCDEHL') = double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_log10 = mm48_log
