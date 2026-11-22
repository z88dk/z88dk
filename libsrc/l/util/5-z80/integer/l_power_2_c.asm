
SECTION code_clib
SECTION code_l

PUBLIC l_power_2_c

l_power_2_c:

   ; Find the power of 2 greater than or equal to c
   ;
   ; enter : c = unsigned char
   ;
   ; exit  : a = power of 2 >= c
   ;         carry set and a==0 if 2^8 is the result
   ; 
   ; uses  : af, bc

   ld a,$80
   ld b,8

loop:

   sla c
   jr c, set_bit
   
   rra
   djnz loop
   
   xor a
   inc a
   ret

set_bit:

   ccf
   ret z

   add a,a
   ret
   