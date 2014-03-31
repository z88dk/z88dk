
XLIB l_mulu_32_24x8
XDEF l0_mulu_32_24x8

LIB l1_mulu_24_16x8

l0_mulu_32_24x8:

   ; enter : ehl = 24-bit multiplicand
   ;           a = 8-bit multiplicand
   
   ld d,e
   ld e,a
   ld a,d

l_mulu_32_24x8:

   ; unsigned multiplication of 24-bit and 8-bit
   ; multiplicands into a 32-bit product
   ;
   ; enter :    e = 8-bit multiplicand
   ;          ahl = 24-bit multiplicand
   ;
   ; exit  : dehl = 32-bit result
   ;            a = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl
   
   ; try to reduce the multiplication
   
   or a
   jp z, l1_mulu_24_16x8

   ; two full size multiplicands

   ld c,e
   ld b,a
   ld e,l
   ld d,h

   ; bde = 24-bit multiplicand
   ;   c = 8-bit multiplicand

   ; eliminate leading zero bits

loop_00:

   sla c
   jr c, loop_11

   sla c
   jr c, loop_12

   sla c
   jr c, loop_13

   sla c
   jr c, loop_14

   sla c
   jr c, loop_15

   sla c
   jr c, loop_16

   sla c
   jr c, loop_17

   sla c
   jr c, exit_18
      
   xor a
   
   ld e,a
   ld d,a
   ld l,a
   ld h,a
   
   ret

   ; general multiplication loop

loop_11:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_12
   
   add hl,de
   adc a,b

loop_12:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_13
   
   add hl,de
   adc a,b

loop_13:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_14
   
   add hl,de
   adc a,b

loop_14:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_15
   
   add hl,de
   adc a,b

loop_15:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_16
   
   add hl,de
   adc a,b

loop_16:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_17
   
   add hl,de
   adc a,b

loop_17:

   add hl,hl
   rla 
   rl c
   
   jr nc, exit_18
   
   add hl,de
   adc a,b

exit_18:

   ; product in cahl
  
   ld e,a
   ld d,c
  
   xor a
   ret
