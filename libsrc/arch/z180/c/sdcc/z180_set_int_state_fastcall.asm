
; void z180_set_int_state_fastcall(uint state)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_set_int_state_fastcall

EXTERN asm_z180_set_int_state

defc _z180_set_int_state_fastcall = asm_z180_set_int_state
