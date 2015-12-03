
SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_open

INCLUDE "clib_target_cfg.asm"

EXTERN __sound_bit_state

asm_bit_open:

   ; exit : a = output byte to use for 1-bit sound
   ;
   ; uses : af
   
   ld a,(__sound_bit_state)
   and __sound_bit_read_mask
   
   ret
