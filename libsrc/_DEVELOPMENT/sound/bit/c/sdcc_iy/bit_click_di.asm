
; void bit_click_di(void)

SECTION code_sound_bit

PUBLIC _bit_click_di

_bit_click_di:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "sound/bit/z80/asm_bit_click_di.asm"
