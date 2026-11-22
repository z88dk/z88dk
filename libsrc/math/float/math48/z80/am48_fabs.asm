
; double fabs(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_fabs

am48_fabs:

   ; return absolute value of x
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = |x|
   ;
   ; uses  : b'
   
   exx
   res 7,b
   exx
   
   ret
