; 2018 July feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z80n_mulu_72_64x8

l_z80n_mulu_72_64x8:

   ; multiplication of a 64-bit number and an 8-bit number into 72-bit result
   ;
   ; enter :   dehl'dehl = 64-bit multiplicand
   ;                   a = 8-bit multiplicand
   ;
   ; exit  : a dehl'dehl = 72-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

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
   ex af,af

   ld d,b                       ; return DE
   ld e,c

   exx

   ld b,d                       ; relocate DE
   ld c,e

   ld e,l
   ld d,a
   mul de                       ; y*x4

   ex af,af
   adc a,e
   ld l,a                       ;'p4
   ld a,d                       ;'p5 carry
   ex af,af

   ld e,h
   ld d,a
   mul de                       ; y*x5

   ex af,af
   adc a,e
   ld h,a                       ;'p5
   ld a,d                       ;'p6 carry
   ex af,af

   ld e,c
   ld d,a
   mul de                       ; y*x6

   ex af,af
   adc a,e
   ld c,a                       ;'p6
   ld a,d                       ;'p7 carry
   ex af,af

   ld e,b
   ld d,a
   mul de                       ; y*x6

   ex af,af
   adc a,e
   ld b,a                       ;'p7
   ld a,d                       ;'p8 carry
   adc a,0                      ;'final carry

   ld d,b                       ; return DE
   ld e,c

   exx
   ret
