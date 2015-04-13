
; uint16_t in_pause_fastcall(uint16_t dur_ms)

SECTION code_input

PUBLIC _in_pause_fastcall

_in_pause_fastcall:

   INCLUDE "input/zx/z80/asm_in_pause.asm"
