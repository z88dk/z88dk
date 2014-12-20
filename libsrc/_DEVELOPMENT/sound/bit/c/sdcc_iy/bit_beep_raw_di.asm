
; void bit_beep_raw_di(uint_16t num_cycles, uint16_t tone_period_T)

SECTION code_sound_bit

PUBLIC _bit_beep_raw_di

_bit_beep_raw_di:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "sound/bit/z80/asm_bit_beep_raw_di.asm"
