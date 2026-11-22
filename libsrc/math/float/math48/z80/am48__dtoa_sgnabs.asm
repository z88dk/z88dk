
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48__dtoa_sgnabs

am48__dtoa_sgnabs:

   ; enter : AC'= double x
   ;
   ; exit  : AC'= |x|
   ;          A = sgn(x) = 1 if negative, 0 otherwise
   ;
   ; uses  : af
   
   exx
   ld a,b
   res 7,b
   exx
   
   rlca
   and $01
   
   ret
