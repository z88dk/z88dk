
; uint8_t z80_inp(uint16_t port)

SECTION seg_code_z80

PUBLIC z80_inp

z80_inp:

   INCLUDE "z80/z80/asm_z80_inp.asm"
