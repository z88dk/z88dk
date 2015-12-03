
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_18

INCLUDE "clib_target_cfg.asm"

_bitfx_18:

   ; steam engine

   ld hl,0

coff2:

   push af
   
   xor __sound_bit_toggle
   and (hl)
   ld b,a
   
   pop af
   
   xor b
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   ld b,(hl)

cdly:

   djnz cdly
   
   inc hl
   
   bit 7,l
   jr z, coff2
   
   ret
