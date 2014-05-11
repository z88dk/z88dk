
; void bit_beep_di(uint16_t duration_ms, uint16_t frequency_hz)

PUBLIC bit_beep_di

EXTERN asm_bit_beep_di

bit_beep_di:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_bit_beep_di
