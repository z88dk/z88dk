
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfp

EXTERN mm48_frac

   ; fraction part of double
   ; AC'= fraction_part(AC')
   ;
   ; AC' is set to the fraction part of AC' with the same sign as AC'
   ;
   ; enter : AC'= double x
   ;
   ; exit  : AC'= fp(x)
   ;
   ; note  : FRAC( 3.7)= 0.7
   ;         FRAC(-3.7)=-0.7
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_dfp = mm48_frac
