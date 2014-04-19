
; void bit_beep_raw_di(uint_16t num_cycles, uint16_t tone_period_T)

XLIB bit_beep_raw_di

LIB asm_bit_beep_raw_di

bit_beep_raw_di:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_bit_beep_raw_di
