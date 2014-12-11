
; void *p_stack_top(p_stack_t *s)

SECTION code_adt_p_stack

PUBLIC p_stack_top

defc p_stack_top = asm_p_stack_top

INCLUDE "adt/p_stack/z80/asm_p_stack_top.asm"
