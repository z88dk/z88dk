
; void bit_beep_raw(uint16_t num_cycles, uint16_t tone_period_T)

XLIB bit_beep_raw

LIB asm_bit_beep_raw

bit_beep_raw:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_bit_beep_raw
