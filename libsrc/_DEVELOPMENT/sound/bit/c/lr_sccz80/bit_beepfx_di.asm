
; void bit_beepfx_di(void *effect)

XDEF bit_beepfx_di

bit_beepfx_di:

   push hl
   pop ix
   
   INCLUDE "sound/bit/z80/asm_bit_beepfx_di.asm"
