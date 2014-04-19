
; void bit_beep(uint16_t duration_ms, uint16_t frequency_hz)

XLIB bit_beep

LIB asm_bit_beep

bit_beep:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_bit_beep
