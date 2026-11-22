
; void bit_beep_raw_callee(uint16_t num_cycles, uint16_t tone_period_T)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_beep_raw_callee

EXTERN asm_bit_beep_raw

bit_beep_raw_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_bit_beep_raw
