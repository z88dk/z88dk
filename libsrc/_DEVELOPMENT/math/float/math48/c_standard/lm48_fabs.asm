
; double fabs(double x)

SECTION code_fp_math48

PUBLIC lm48_fabs

lm48_fabs:

   ; return absolute value of x
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : AC'(BCDEHL') = |x|
   ;
   ; uses  : b'
   
   exx
   res 7,b
   exx
   
   ret
