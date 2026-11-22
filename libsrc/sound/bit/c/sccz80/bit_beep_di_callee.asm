
; void bit_beep_di_callee(uint16_t duration_ms, uint16_t frequency_hz)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_beep_di_callee

EXTERN asm_bit_beep_di

bit_beep_di_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_bit_beep_di
