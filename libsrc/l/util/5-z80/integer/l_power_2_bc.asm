
SECTION code_clib
SECTION code_l

PUBLIC l_power_2_bc

EXTERN l_power_2_c

l_power_2_bc:

   ; Find the power of 2 greater than or equal to bc
   ;
   ; enter : bc = unsigned int
   ;
   ; exit  : bc = power of 2 >= bc
   ;         carry set if 2^16 is the result
   ;
   ; uses  : af, bc
   
   ld a,b
   or a
   jr z, bits_8
   
bits_16:

   ld c,b
   call l_power_2_c
   
   ld b,a
   ld c,0
   ret

bits_8:

   call l_power_2_c
   
   ld c,a
   ld b,0
   ret nc
   
   inc b
   ccf
   ret
