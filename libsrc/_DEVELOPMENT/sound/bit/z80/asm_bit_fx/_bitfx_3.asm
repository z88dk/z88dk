
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_3

INCLUDE "clib_target_cfg.asm"

_bitfx_3:

   ; Eating sound
   
   ld h,4

zap0_1:

   ld b,(hl)
   dec hl

zap0_2:

   djnz zap0_2

   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"
   
   ld c,a
   
   ld a,h
   or l
   ret z
   
   ld a,c
   jr zap0_1
