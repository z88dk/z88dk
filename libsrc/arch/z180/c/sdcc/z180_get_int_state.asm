
; uint z180_get_int_state(void)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_get_int_state

EXTERN asm_z180_get_int_state

defc _z180_get_int_state = asm_z180_get_int_state
