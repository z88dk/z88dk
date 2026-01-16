
; void z180_set_int_state(uint state)

SECTION code_clib
SECTION code_z180

PUBLIC z180_set_int_state

EXTERN asm_z180_set_int_state

defc z180_set_int_state = asm_z180_set_int_state
