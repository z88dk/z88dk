
XLIB asm_bit_open

INCLUDE "clib_target_cfg.asm"

XREF __sound_bit_state

asm_bit_open:

   ; exit : a = output byte to use for 1-bit sound
   ;
   ; uses : af
   
   ld a,(__sound_bit_state)
   and __sound_bit_read_mask
   ret
