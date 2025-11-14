; 2018 July feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z80n_mulu_32_16x16

l_z80n_mulu_32_16x16:

   ; multiplication of two 16-bit numbers into a 32-bit product
   ;
   ; enter : de = 16-bit multiplicand = y
   ;         hl = 16-bit multiplicand = x
   ;
   ; exit  : dehl = 32-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

   ld b,l                      ; x0
   ld c,e                      ; y0
   ld e,l                      ; x0
   ld l,d
   push hl                     ; x1 y1
   ld l,c                      ; y0

   ; bc = x0 y0
   ; de = y1 x0
   ; hl = x1 y0
   ; stack = x1 y1

   mul de                      ; y1*x0
   ex de,hl
   mul de                      ; x1*y0

   xor a                       ; zero A
   add hl,de                   ; sum cross products p2 p1
   adc a,a                     ; capture carry p3

   ld e,c                      ; x0
   ld d,b                      ; y0
   mul de                      ; y0*x0

   ld b,a                      ; carry from cross products
   ld c,h                      ; LSB of MSW from cross products

   ld a,d
   add a,l
   ld h,a
   ld l,e                      ; LSW in HL p1 p0

   pop de
   mul de                      ; x1*y1

   ex de,hl
   adc hl,bc
   ex de,hl                    ; de = final MSW

   ret
