
; void *bit_play_tritone_di(void *song)

PUBLIC _bit_play_tritone_di

_bit_play_tritone_di:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "sound/bit/z80/asm_bit_play_tritone_di.asm"
