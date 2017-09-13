
; void z180_pop_ei(void)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_pop_ei

EXTERN asm_z180_pop_ei

defc _z180_pop_ei = asm_z180_pop_ei

