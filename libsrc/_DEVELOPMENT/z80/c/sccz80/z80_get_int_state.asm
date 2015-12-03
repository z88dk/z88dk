
; uint z80_get_int_state(void)

SECTION code_clib
SECTION code_z80

PUBLIC z80_get_int_state

EXTERN asm_z80_get_int_state

defc z80_get_int_state = asm_z80_get_int_state
