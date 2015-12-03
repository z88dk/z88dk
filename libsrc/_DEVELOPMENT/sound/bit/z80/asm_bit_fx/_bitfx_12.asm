
SECTION smc_clib
SECTION smc_sound_bit

PUBLIC _bitfx_12

INCLUDE "clib_target_cfg.asm"

EXTERN asm_bit_open

_bitfx_12:

   ; TSpace 2
   
   ld a,230
   ld (ts_FR_1 + 1),a
   
   xor a
   ld (ts_FR_2 + 1),a
   
   call asm_bit_open
   ld b,200

t2_loop:

   dec h
   jr nz, t2_jump
   
   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push bc
   ld b,250

wait1:

   djnz wait1
   
   pop bc
   
   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

ts_FR_1:

   ld h,230

t2_jump:

   inc l
   jr nz, t2_loop
   
   push af
   
   ld a,(ts_FR_2 + 1)
   inc a
   ld (ts_FR_2 + 1),a
   
   pop af
   
   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push bc
   ld b,200

wait2:

   djnz wait2
   
   pop bc
   
   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

ts_FR_2:

   ld l,0
   djnz t2_loop
   
   ret
