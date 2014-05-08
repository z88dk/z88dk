
; void bit_fx(void *effect)

PUBLIC _bit_fx

_bit_fx:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_bit_fx
   
   pop ix
   ret
   
   INCLUDE "sound/bit/z80/asm_bit_fx.asm"
