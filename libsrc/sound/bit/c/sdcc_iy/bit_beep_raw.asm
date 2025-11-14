
; void bit_beep_raw(uint16_t num_cycles, uint16_t tone_period_T)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beep_raw

EXTERN asm_bit_beep_raw

_bit_beep_raw:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
      
   jp asm_bit_beep_raw
