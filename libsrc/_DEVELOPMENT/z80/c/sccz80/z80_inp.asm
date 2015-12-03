
; uint8_t z80_inp(uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC z80_inp

EXTERN asm_z80_inp

defc z80_inp = asm_z80_inp
