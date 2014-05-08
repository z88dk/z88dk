
; void bit_beep_di(uint16_t duration_ms, uint16_t frequency_hz)

PUBLIC _bit_beep_di

_bit_beep_di:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   
   call asm_bit_beep_di
   
   pop ix
   ret
   
   INCLUDE "sound/bit/z80/asm_bit_beep_di.asm"
