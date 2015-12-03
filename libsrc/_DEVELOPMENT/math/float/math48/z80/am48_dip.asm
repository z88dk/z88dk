
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dip

EXTERN mm48_int

   ; integer part of double
   ; AC'= integer_part(AC')
   ;
   ; if AC'>=0: AC' is set equal to the nearest integer that is
   ;                less than or equal to the number in AC'.
   ;
   ; if AC'< 0: AC' is set equal to the nearest integer that is
   ;                larger than or equal to the number in AC'.
   ;
   ; enter : AC'= double x
   ;
   ; exit  : AC'= fp(x)
   ;
   ; note  : INT( 3.7)= 3
   ;         INT(-3.7)=-3
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_dip = mm48_int
