
; void *bit_play_tritone_di(void *song)

XDEF _bit_play_tritone_di

_bit_play_tritone_di:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_bit_play_tritone_di
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_play_tritone_di.asm"
