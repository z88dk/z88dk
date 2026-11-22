
SECTION smc_clib
SECTION smc_sound_bit

PUBLIC _bitfx_13

INCLUDE "config_private.inc"

EXTERN asm_bit_open

_bitfx_13:

   ; TSpace 3

   ld a,230
   ld (u2_FR_1 + 1),a
   
   xor a
   ld (u2_FR_2 + 1),a
   
   call asm_bit_open
   ld b,200

u2_loop:

   dec h
   jr nz, u2_jump
   
   push af
   
   ld a,(u2_FR_1 + 1)
   inc a
   ld (u2_FR_1 + 1),a
   
   pop af
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

u2_FR_1:

   ld h,50

u2_jump:

   inc l
   jr nz, u2_loop
   
   push af
   
   ld a,(u2_FR_2 + 1)
   inc a
   ld (u2_FR_2 + 1),a
   
   pop af
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

u2_FR_2:

   ld l,0
   djnz u2_loop
   
   ret
