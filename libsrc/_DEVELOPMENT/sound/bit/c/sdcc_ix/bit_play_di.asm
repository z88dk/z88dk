
; char *bit_play_di(char *melody)

SECTION code_sound_bit

PUBLIC _bit_play_di

_bit_play_di:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_bit_play_di
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_play_di.asm"
