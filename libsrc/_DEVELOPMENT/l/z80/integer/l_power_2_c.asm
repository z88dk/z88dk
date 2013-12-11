
XLIB l_power_2_c

l_power_2_c:

   ; Find the power of 2 greater than or equal to c
   ;
   ; enter : c = unsigned char
   ;
   ; exit  : a = power of 2 >= c
   ;         carry set if 2^8 is the result
   ; 
   ; uses  : af, b
   
   ld a,128

loop:

   ld b,a
   and c
   ld a,b
   
   jr nz, set_bit
   
   rra
   jp nc, loop

was_zero:

   xor a
   inc a
   ret

set_bit:

   cp c
   ret z
   
   add a,a
   ret

   