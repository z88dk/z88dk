
; uint z80_get_int_state(void)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_get_int_state

EXTERN asm_z80_get_int_state

defc _z80_get_int_state = asm_z80_get_int_state
