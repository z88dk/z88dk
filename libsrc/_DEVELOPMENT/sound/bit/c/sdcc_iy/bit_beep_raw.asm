
; void bit_beep_raw(uint16_t num_cycles, uint16_t tone_period_T)

XDEF _bit_beep_raw

_bit_beep_raw:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
      
   INCLUDE "sound/bit/z80/asm_bit_beep_raw.asm"
