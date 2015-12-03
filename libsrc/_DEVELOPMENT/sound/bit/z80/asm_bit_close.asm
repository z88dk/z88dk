
SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_close

INCLUDE "clib_target_cfg.asm"

EXTERN __sound_bit_state

asm_bit_close:

   ; enter : a = output byte used for 1-bit sound
   ;
   ; uses : af, c
   
   ld c,a
   
   ld a,(__sound_bit_state)
   and __sound_bit_write_mask
   
   or c
   ld (__sound_bit_state),a
   
   ret
