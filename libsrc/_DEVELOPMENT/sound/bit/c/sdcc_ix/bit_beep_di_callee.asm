
; void bit_beep_di_callee(uint16_t duration_ms, uint16_t frequency_hz)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beep_di_callee, l0_bit_beep_di_callee

EXTERN asm_bit_beep_di

_bit_beep_di_callee:

   pop af
   pop hl
   pop de
   push af

l0_bit_beep_di_callee:

   push ix
   
   call asm_bit_beep_di
   
   pop ix
   ret
