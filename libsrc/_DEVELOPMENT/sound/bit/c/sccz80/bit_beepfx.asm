
; void bit_beepfx(void *effect)

SECTION code_sound_bit

PUBLIC bit_beepfx

bit_beepfx:

   push hl
   pop ix
   
   INCLUDE "sound/bit/z80/asm_bit_beepfx.asm"
