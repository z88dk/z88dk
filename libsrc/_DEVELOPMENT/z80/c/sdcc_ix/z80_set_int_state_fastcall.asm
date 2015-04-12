
; void z80_set_int_state_fastcall(uint state)

SECTION code_z80

PUBLIC _z80_set_int_state_fastcall

_z80_set_int_state_fastcall:

   INCLUDE "z80/z80/asm_z80_set_int_state.asm"
