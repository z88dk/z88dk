
; uint16_t in_pause(uint16_t dur_ms)

SECTION seg_code_input

PUBLIC in_pause

in_pause:

   INCLUDE "input/zx/z80/asm_in_pause.asm"
