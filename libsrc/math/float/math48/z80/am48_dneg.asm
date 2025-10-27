
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dneg

EXTERN mm48_negate

am48_dneg:

   ; negate AC'
   ;
   ; enter : AC'= double x
   ;
   ; exit  : AC'= -x
   ;
   ; uses  : af, bc', de', hl'
   
   exx
   call mm48_negate
   exx
   ret
