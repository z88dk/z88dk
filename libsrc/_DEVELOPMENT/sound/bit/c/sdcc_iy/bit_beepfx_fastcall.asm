
; void bit_beepfx_fastcall(void *effect)

SECTION code_sound_bit

PUBLIC _bit_beepfx_fastcall

_bit_beepfx_fastcall:

   push hl
   pop ix
   
   INCLUDE "sound/bit/z80/asm_bit_beepfx.asm"
