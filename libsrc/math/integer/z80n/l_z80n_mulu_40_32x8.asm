; 2018 July feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z80n_mulu_40_32x8

l_z80n_mulu_40_32x8:

    ; multiplication of 32-bit number and 8-bit number into a 40-bit product
    ;
    ; enter :    a  = 8-bit multiplier     = x
    ;         dehl  = 32-bit multiplicand  = y
    ;            
    ; exit  : adehl = 40-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af'

   ld b,d                       ; relocate DE
   ld c,e

   ld e,l                       ; x0
   ld d,a
   mul de                       ; y*x0

   ex af,af                     ;'accumulator
   ld l,e                       ;'p0
   ld a,d                       ;'p1 carry
   ex af,af

   ld e,h                       ; x1
   ld d,a
   mul de                       ; y*x1

   ex af,af
   add a,e
   ld h,a                       ;'p1
   ld a,d                       ;'p2 carry
   ex af,af

   ld e,c
   ld d,a
   mul de                       ; y*x2

   ex af,af
   adc a,e
   ld c,a                       ;'p2
   ld a,d                       ;'p3 carry
   ex af,af

   ld e,b
   ld d,a
   mul de                       ; y*x3

   ex af,af
   adc a,e
   ld b,a                       ;'p3
   ld a,d                       ;'p4 carry
   adc a,0                      ;'final carry

   ld d,b                       ; return DE
   ld e,c

   ret
