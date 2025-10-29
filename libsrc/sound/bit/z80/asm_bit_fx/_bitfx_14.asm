
SECTION smc_clib
SECTION smc_sound_bit

PUBLIC _bitfx_14

INCLUDE "config_private.inc"

EXTERN asm_bit_open

_bitfx_14:

   ; Squoink

   ld a,230
   ld (qi_FR_1 + 1),a
   
   xor a
   ld (qi_FR_2 + 1),a
   
   call asm_bit_open
   ld b,200

qi_loop:

   dec h
   jr nz, qi_jump
   
   push af
   
   ld a,(qi_FR_1 + 1)
   dec a
   ld (qi_FR_1 + 1),a
   
   pop af
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

qi_FR_1:

   ld h,50

qi_jump:

   inc l
   jr nz, qi_loop
   
   push af
   
   ld a,(qi_FR_2 + 1)
   inc a
   ld (qi_FR_2 + 1),a
   
   pop af
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

qi_FR_2:

   ld l,0
   djnz qi_loop
   
   ret
