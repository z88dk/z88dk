
XLIB l_fast_mulu_24_16x8
XDEF l0_fast_mulu_24_16x8, l1_fast_mulu_24_16x8

l_fast_mulu_24_16x8:

   ; unsigned multiplication of 16-bit and 8-bit
   ; multiplicands into a 24-bit product
   ;
   ; enter :  e = 8-bit multiplicand
   ;         hl = 16-bit multiplicand
   ;
   ; exit  : ahl = 24-bit product
   ;           c = 0
   ;         carry reset
   ;
   ; uses  : af, c, de, hl

   ld a,e
   ld e,l
   ld d,h

   ; de = 16-bit multiplicand
   ;  a = 8-bit multiplicand
   
   ld c,0
   
   ; eliminate leading zero bits

loop_00:

   add a,a
   jr c, loop_11

   add a,a
   jr c, loop_12

   add a,a
   jr c, loop_13

   add a,a
   jr c, loop_14

   add a,a
   jr c, loop_15

   add a,a
   jr c, loop_16

   add a,a
   jr c, loop_17

   add a,a
   ccf
   ret nc
   
   xor a
   ld l,a
   ld h,a
   
   ret

   ; general multiplication loop

loop_11:

   add hl,hl
   rla
   
   jr nc, loop_12

   add hl,de
   adc a,c

loop_12:

   add hl,hl
   rla
   
   jr nc, loop_13

   add hl,de
   adc a,c

loop_13:

   add hl,hl
   rla
   
   jr nc, loop_14

   add hl,de
   adc a,c

loop_14:

   add hl,hl
   rla
   
   jr nc, loop_15

   add hl,de
   adc a,c

loop_15:

   add hl,hl
   rla
   
   jr nc, loop_16

   add hl,de
   adc a,c

loop_16:

   add hl,hl
   rla
   
   jr nc, loop_17

   add hl,de
   adc a,c

loop_17:

   add hl,hl
   rla
   
   ret nc

   add hl,de
   adc a,c

   ret


; versions to return 32-bit result

l0_fast_mulu_24_16x8:

   ex de,hl

l1_fast_mulu_24_16x8:

   ; enter :  e = 8-bit multiplicand
   ;         hl = 16-bit multiplicand
   ;
   ; exit  : dehl = 24-bit product
   ;            a = 0
   ;            c = 0
   ;            d = 0
   ;         carry reset
   ;
   ; uses  : af, c, de, hl
   
   call l_fast_mulu_24_16x8
   
   ld e,a
   ld d,c
   
   xor a
   ret
