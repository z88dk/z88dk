
; void bit_beep_raw_di(uint_16t num_cycles, uint16_t tone_period_T)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beep_raw_di

EXTERN l0_bit_beep_raw_di_callee

_bit_beep_raw_di:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_bit_beep_raw_di_callee
