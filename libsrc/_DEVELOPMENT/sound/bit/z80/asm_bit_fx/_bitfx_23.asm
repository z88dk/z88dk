
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_23

INCLUDE "clib_target_cfg.asm"

_bitfx_23:

   ; noise 7

   ld hl,4000

fx71:

   push hl
   push af
   
   ld a,__sound_bit_toggle
   and l
   ld l,a
   
   pop af
   
   xor l
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   pop hl
   dec hl
   
   ld c,a
   
   ld a,h
   or l
   
   ld a,c
   jr nz, fx71
   
   ret
