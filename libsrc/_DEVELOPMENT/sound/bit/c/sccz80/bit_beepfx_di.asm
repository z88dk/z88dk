
; void bit_beepfx_di(void *effect)

SECTION code_sound_bit

PUBLIC bit_beepfx_di

bit_beepfx_di:

   push hl
   pop ix
   
   INCLUDE "sound/bit/z80/asm_bit_beepfx_di.asm"
