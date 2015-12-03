
; void z80_set_int_state_fastcall(uint state)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_set_int_state_fastcall

EXTERN asm_z80_set_int_state

defc _z80_set_int_state_fastcall = asm_z80_set_int_state
