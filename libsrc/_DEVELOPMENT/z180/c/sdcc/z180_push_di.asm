
; void z180_push_di(void)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_push_di

EXTERN asm_z180_push_di

defc _z180_push_di = asm_z180_push_di

