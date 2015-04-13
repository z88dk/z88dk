
; void bit_beepfx_di_fastcall(void *effect)

SECTION code_sound_bit

PUBLIC _bit_beepfx_di_fastcall

_bit_beepfx_di_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_bit_beepfx_di
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_beepfx_di.asm"
