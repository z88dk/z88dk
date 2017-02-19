
SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_open

INCLUDE "config_private.inc"

EXTERN __sound_bit_state

asm_bit_open:

   ; exit : a = output byte to use for 1-bit sound
   ;
   ; uses : af
   
   ld a,(__sound_bit_state)
   and __SOUND_BIT_READ_MASK
   
   ret
