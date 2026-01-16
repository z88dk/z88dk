
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dmul10a

EXTERN mm48_mul10

   ; multiply AC' by 10 and make positive
   ; 
   ; enter : AC'= double x
   ;
   ; exit  : success
   ;
   ;            AC'= abs(x) * 10
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= +inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc', de', hl'

defc am48_dmul10a = mm48_mul10
