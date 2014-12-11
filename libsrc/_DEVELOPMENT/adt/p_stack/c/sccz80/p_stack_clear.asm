
; void p_stack_clear(p_stack_t *s)

SECTION code_adt_p_stack

PUBLIC p_stack_clear

defc p_stack_clear = asm_p_stack_clear

INCLUDE "adt/p_stack/z80/asm_p_stack_clear.asm"
