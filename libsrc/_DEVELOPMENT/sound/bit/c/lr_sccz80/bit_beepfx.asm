
; void bit_beepfx(void *effect)

XDEF bit_beepfx

bit_beepfx:

   push hl
   pop ix
   
   INCLUDE "sound/bit/z80/asm_bit_beepfx.asm"
