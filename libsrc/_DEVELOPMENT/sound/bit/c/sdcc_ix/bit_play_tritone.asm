
; void *bit_play_tritone(void *song)

PUBLIC _bit_play_tritone

_bit_play_tritone:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_bit_play_tritone
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_play_tritone.asm"
