
; void *p_stack_pop(p_stack_t *s)

SECTION code_adt_p_stack

PUBLIC p_stack_pop

defc p_stack_pop = asm_p_stack_pop

INCLUDE "adt/p_stack/z80/asm_p_stack_pop.asm"
