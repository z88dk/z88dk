
; void bit_beep_di(uint16_t duration_ms, uint16_t frequency_hz)

XLIB bit_beep_di

LIB asm_bit_beep_di

bit_beep_di:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_bit_beep_di
