
; void bit_beep_di(uint16_t duration_ms, uint16_t frequency_hz)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beep_di

EXTERN l0_bit_beep_di_callee

_bit_beep_di:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_bit_beep_di_callee
