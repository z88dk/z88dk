; 2018 June feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z180_mulu_40_32x8

l_z180_mulu_40_32x8:

    ; multiplication of 32-bit number and 8-bit number into a 40-bit product
    ;
    ; enter :    a  = 8-bit multiplier     = x
    ;         dehl  = 32-bit multiplicand  = y
    ;            
    ; exit  : adehl = 40-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af'

   ld c,l                       ; x0
   ld b,a
   mlt bc                       ; y*x0

   ex af,af                     ;'accumulator
   ld l,c                       ;'p0
   ld a,b                       ;'p1 carry
   ex af,af

   ld c,h                       ; x1
   ld b,a
   mlt bc                       ; y*x1

   ex af,af
   add a,c
   ld h,a                       ;'p1
   ld a,b                       ;'p2 carry
   ex af,af

   ld c,e
   ld b,a
   mlt bc                       ; y*x2

   ex af,af
   adc a,c
   ld e,a                       ;'p2
   ld a,b                       ;'p3 carry
   ex af,af

   ld c,d
   ld b,a
   mlt bc                       ; y*x3

   ex af,af
   adc a,c
   ld d,a                       ;'p3
   ld a,b                       ;'p4 carry
   adc a,0                      ;'final carry

   ret
