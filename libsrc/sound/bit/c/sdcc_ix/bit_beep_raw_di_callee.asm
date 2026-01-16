
; void bit_beep_raw_di_callee(uint_16t num_cycles, uint16_t tone_period_T)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beep_raw_di_callee, l0_bit_beep_raw_di_callee

EXTERN asm_bit_beep_raw_di

_bit_beep_raw_di_callee:

   pop af
   pop hl
   pop de
   push af

l0_bit_beep_raw_di_callee:

   push ix
   
   call asm_bit_beep_raw_di
   
   pop ix
   ret
