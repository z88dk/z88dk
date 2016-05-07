
SECTION code_clib
SECTION code_l

PUBLIC l_add_64_dehldehl_a

EXTERN l0_inc_64_dehldehl

l_add_64_dehldehl_a:

   ; add 64-bit number and 8-bit number
   ;
   ; enter : dehl'dehl = 64-bit number
   ;                 a = 8-bit number
   ;
   ; exit  : dehl'dehl += a
   ;         z flag set if overflow
   ;
   ; uses  : af, de, hl, de', hl'
   
   add a,l
   ld l,a
   ret nc

   jp l0_inc_64_dehldehl
