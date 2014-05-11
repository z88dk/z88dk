
; void bit_beep_raw_di_callee(uint_16t num_cycles, uint16_t tone_period_T)

PUBLIC bit_beep_raw_di_callee

bit_beep_raw_di_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "sound/bit/z80/asm_bit_beep_raw_di.asm"
