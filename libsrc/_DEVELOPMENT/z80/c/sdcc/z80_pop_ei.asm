
; void z80_pop_ei(void)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_pop_ei

EXTERN asm_z80_pop_ei

defc _z80_pop_ei = asm_z80_pop_ei

