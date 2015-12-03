
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double8u

EXTERN am48_double16u

am48_double8u:

   ; 8-bit unsigned integer to double
   ;
   ; enter :  L = 8-bit unsigned integer n
   ;
   ; exit  : AC = AC' (exx set saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld h,0
   jp am48_double16u
