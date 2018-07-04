
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_z80_zxn_mulu_32_16x16

l_z80_zxn_mulu_32_16x16:

   ; multiplication of two 16-bit numbers into a 32-bit product
   ;
   ; enter : de = 16-bit multiplicand = y
   ;         hl = 16-bit multiplicand = x
   ;
   ; exit  : dehl = 32-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

   ld b,l                      ; xl
   ld c,e                      ; yl
   ld e,l                      ; xl
   ld l,d
   push hl                     ; xh yh
   ld l,c                      ; yl

   ; bc = xl yl
   ; de = yh xl
   ; hl = xh yl
   ; stack = xh yh

   mlt de                      ; xl * yh
   ex de,hl
   mlt de                      ; xh * yl

   add hl,de                   ; sum cross products

   sbc a,a
   and $01                     ; carry from cross products

   ld e,c                      ; xl
   ld d,b                      ; yl
   mlt de                      ; xl * yl

   ld b,a                      ; carry from cross products
   ld c,h                      ; LSB of MSW from cross products

   ld a,d
   add a,l
   ld h,a
   ld l,e                      ; hl = final LSW

   pop de
   mlt de                      ; xh * yh

   ex de,hl
   adc hl,bc
   ex de,hl                    ; de = final MSW

   ; 154 cycles, 32 bytes

   ret
