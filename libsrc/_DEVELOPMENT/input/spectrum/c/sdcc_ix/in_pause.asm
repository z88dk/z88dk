
; uint16_t in_pause(uint16_t dur_ms)

XDEF _in_pause

_in_pause:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "input/spectrum/z80/asm_in_pause.asm"
