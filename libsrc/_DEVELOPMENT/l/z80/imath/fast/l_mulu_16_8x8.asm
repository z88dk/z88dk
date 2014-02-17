
XLIB l_mulu_16_8x8

l_mulu_16_8x8:

   ; unsigned multiplication of two 8-bit
   ; multiplicands into a sixteen bit product
   ;
   ; enter : l = 8-bit multiplicand
   ;         e = 8-bit multiplicand
   ;
   ; exit  : hl = 16-bit product
   ;          a = 0
   ;          d = 0
   ;         carry reset
   ;
   ; uses  : af, de, hl

   ld h,l
   ld l,e
   
   xor a
   ld d,a

   ; eliminate leading zero bits

loop_00:

   sla h
   jr c, loop_11
   
   sla h
   jr c, loop_12
   
   sla h
   jr c, loop_13

   sla h
   jr c, loop_14

   sla h
   jr c, loop_15
   
   sla h
   jr c, loop_16
   
   sla h
   jr c, loop_17

   sla h
   ccf
   ret nc

   xor a
   ld l,a
   ret

   ; general multiplication loop

loop_11:
   
   add hl,hl
   jr nc, loop_12
   add hl,de

loop_12:

   add hl,hl
   jr nc, loop_13
   add hl,de

loop_13:

   add hl,hl
   jr nc, loop_14
   add hl,de

loop_14:

   add hl,hl
   jr nc, loop_15
   add hl,de

loop_15:

   add hl,hl
   jr nc, loop_16
   add hl,de

loop_16:

   add hl,hl
   jr nc, loop_17
   add hl,de

loop_17:

   add hl,hl
   ret nc
   add hl,de
   ret
