
; void bit_beep(uint16_t duration_ms, uint16_t frequency_hz)

SECTION code_sound_bit

PUBLIC _bit_beep_callee, l0_bit_beep_callee

_bit_beep_callee:

   pop hl
   pop de
   ex (sp),hl

l0_bit_beep_callee:

   push ix
   
   call asm_bit_beep
   
   pop ix
   ret
   
   INCLUDE "sound/bit/z80/asm_bit_beep.asm"
