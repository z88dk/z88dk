
; void bit_fx_di_fastcall(void *effect)

SECTION code_sound_bit

PUBLIC _bit_fx_di_fastcall

_bit_fx_di_fastcall:
   
   push ix
   
   call asm_bit_fx_di
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_fx_di.asm"
