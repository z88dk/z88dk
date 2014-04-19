
; void bit_fx(void *effect)

XDEF _bit_fx

_bit_fx:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "sound/bit/z80/asm_bit_fx.asm"
