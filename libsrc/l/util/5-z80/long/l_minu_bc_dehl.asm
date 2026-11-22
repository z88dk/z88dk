
SECTION code_clib
SECTION code_l

PUBLIC l_minu_bc_dehl

EXTERN l_minu_bc_hl

l_minu_bc_dehl:

   ; return unsigned minimum of bc and dehl
   ;
   ; enter :   bc = unsigned 16 bit number
   ;         dehl = unsigned 32 bit number
   ;
   ; exit  :   hl = smaller of the two unsigned numbers
   ;         carry set if dehl was smaller, z flag set if equal
   ;
   ; uses  : af, hl
   
   ld a,d
   or e
   jp z, l_minu_bc_hl
   
   ld l,c
   ld h,b
   
   ret
