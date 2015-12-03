
; void z80_set_int_state(uint state)

SECTION code_clib
SECTION code_z80

PUBLIC z80_set_int_state

EXTERN asm_z80_set_int_state

defc z80_set_int_state = asm_z80_set_int_state
