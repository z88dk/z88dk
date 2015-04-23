
; void bit_beep_di_callee(uint16_t duration_ms, uint16_t frequency_hz)

SECTION code_sound_bit

PUBLIC _bit_beep_di_callee, l0_bit_beep_di_callee

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
   
   INCLUDE "sound/bit/z80/asm_bit_beep_di.asm"
