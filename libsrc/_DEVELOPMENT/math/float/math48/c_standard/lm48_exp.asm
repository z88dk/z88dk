
; double exp(double x)

SECTION code_fp_math48

PUBLIC lm48_exp

EXTERN mm48_exp

   ; computes base-e exponential of x
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = e^x
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max
   ;            carry set, errno set
   ;
   ; uses   : af, af', bc', de', hl'

defc lm48_exp = mm48_exp
