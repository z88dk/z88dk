
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double8

EXTERN am48_double8u, am48_double8u_0

am48_double8:

   ; 8-bit integer to double
   ;
   ; enter :  L = 8-bit integer n
   ;
   ; exit  : AC = AC' (AC' saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   ld a,l
   or a
   jp p, am48_double8u
   
   neg
   
   call am48_double8u_0
   
   exx
   set 7,b
   exx
   
   ret
