
; uint z80_get_int_state(void)

SECTION seg_code_z80

PUBLIC z80_get_int_state

z80_get_int_state:

   INCLUDE "z80/z80/asm_z80_get_int_state.asm"
