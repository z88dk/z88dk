
; void bit_beep_callee(uint16_t duration_ms, uint16_t frequency_hz)

SECTION code_sound_bit

PUBLIC _bit_beep_callee

_bit_beep_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "sound/bit/z80/asm_bit_beep.asm"
