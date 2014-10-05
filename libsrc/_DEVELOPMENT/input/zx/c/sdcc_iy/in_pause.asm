
; uint16_t in_pause(uint16_t dur_ms)

SECTION seg_code_input

PUBLIC _in_pause

_in_pause:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "input/zx/z80/asm_in_pause.asm"
