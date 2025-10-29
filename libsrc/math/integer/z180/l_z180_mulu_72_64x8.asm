; 2018 June feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z180_mulu_72_64x8

l_z180_mulu_72_64x8:

   ; multiplication of a 64-bit number and an 8-bit number into 72-bit result
   ;
   ; enter :   dehl'dehl = 64-bit multiplicand
   ;                   a = 8-bit multiplicand
   ;
   ; exit  : a dehl'dehl = 72-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

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
   ex af,af

   exx

   ld c,l
   ld b,a
   mlt bc                       ; y*x4

   ex af,af
   adc a,c
   ld l,a                       ;'p4
   ld a,b                       ;'p5 carry
   ex af,af

   ld c,h
   ld b,a
   mlt bc                       ; y*x5

   ex af,af
   adc a,c
   ld h,a                       ;'p5
   ld a,b                       ;'p6 carry
   ex af,af

   ld c,e
   ld b,a
   mlt bc                       ; y*x6

   ex af,af
   adc a,c
   ld e,a                       ;'p6
   ld a,b                       ;'p7 carry
   ex af,af

   ld c,d
   ld b,a
   mlt bc                       ; y*x6

   ex af,af
   adc a,c
   ld d,a                       ;'p7
   ld a,b                       ;'p8 carry
   adc a,0                      ;'final carry

   exx
   ret
