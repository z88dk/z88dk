;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;

SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___mululong2ulonglong
PUBLIC l0_sdcc_mul_32_32_64

EXTERN l_mulu_64_64x64, l_store_64_dehldehl_mbc

___mululong2ulonglong:

   ; unsigned 32 x 32 -> 64
   ;
   ; enter :         +-------------------------------
   ;                 | +11
   ;                 | ...  multiplicand (4 bytes)
   ;                 | +8
   ;         stack = |-------------------------------
   ;                 | +7
   ;                 | ...  multiplicand (4 bytes)
   ;                 | +4
   ;                 |-------------------------------
   ;                 | +3
   ;                 | +2   product *
   ;                 |-------------------------------
   ;                 | +1
   ;                 | +0   return address
   ;                 +-------------------------------
   ;
   ; exit  : *product = 64-bit product
   ;         stack unchanged (caller removes 10 bytes)
   ;         ix unchanged
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   ;
   ; l0 entry: bit 0 of b set sign-extends both factors.
   ;           bit 0 of b reset zero-extends them.

   ld b,0

l0_sdcc_mul_32_32_64:

   push ix

   ld hl,-16
   add hl,sp
   ld sp,hl                    ; 16-byte product workspace

   ld ix,0
   add ix,sp                   ; ix = workspace

   ; ix+0  extended factor (8 bytes)
   ; ix+8  extended factor (8 bytes)
   ; ix+16 saved ix
   ; ix+18 return address
   ; ix+20 product *
   ; ix+22 factor (4 bytes)
   ; ix+26 factor (4 bytes)

   push ix
   pop hl
   ld de,hl
   ld hl,22
   add hl,de
   ex de,hl                    ; de = ix+22, hl = ix+0
   call widen

   ld de,hl                    ; de = ix+8
   ld hl,18
   add hl,de
   ex de,hl                    ; de = ix+26, hl = ix+8
   call widen

   call l_mulu_64_64x64        ; dehl'dehl = product

   ld c,(ix+20)
   ld b,(ix+21)                ; bc = product *

   call l_store_64_dehldehl_mbc

   ld hl,16
   add hl,sp
   ld sp,hl                    ; drop the workspace
   pop ix
   ret

; Extend the 4 bytes at de into the 8 bytes at hl.
; b bit 0 selects the high half: 0 fills zero, 1 fills the sign.
; exit: hl = hl+8. b is preserved.

widen:

   ld c,4

w_copy:

   ld a,(de)
   ld (hl),a
   inc de
   inc hl
   dec c
   jr nz, w_copy

   bit 0,b
   jr z, w_zero

   rlca
   sbc a,a
   jr w_fill

w_zero:

   xor a

w_fill:

   ld c,4

w_byte:

   ld (hl),a
   inc hl
   dec c
   jr nz, w_byte
   ret
