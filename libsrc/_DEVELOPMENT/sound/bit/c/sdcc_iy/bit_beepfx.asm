
; void bit_beepfx(void *effect)

SECTION code_sound_bit

PUBLIC _bit_beepfx

_bit_beepfx:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "sound/bit/z80/asm_bit_beepfx.asm"
