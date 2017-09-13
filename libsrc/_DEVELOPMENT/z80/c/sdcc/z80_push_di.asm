
; void z80_push_di(void)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_push_di

EXTERN asm_z80_push_di

defc _z80_push_di = asm_z80_push_di

