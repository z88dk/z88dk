
; void bit_fx_di(void *effect)

PUBLIC _bit_fx_di

_bit_fx_di:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_bit_fx_di
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_fx_di.asm"
