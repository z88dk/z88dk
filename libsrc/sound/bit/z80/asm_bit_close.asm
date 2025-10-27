
SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_close

INCLUDE "config_private.inc"

EXTERN __sound_bit_state

asm_bit_close:

   ; enter : a = output byte used for 1-bit sound
   ;
   ; uses : af, c
   
   ld c,a
   
   ld a,(__sound_bit_state)
   and __SOUND_BIT_WRITE_MASK
   
   or c
   ld (__sound_bit_state),a
   
   ret
