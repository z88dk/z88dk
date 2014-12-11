
; void *p_stack_pop(p_stack_t *s)

SECTION code_adt_p_stack

PUBLIC _p_stack_pop

EXTERN _p_forward_list_remove_after

defc _p_stack_pop = _p_forward_list_remove_after

INCLUDE "adt/p_stack/z80/asm_p_stack_pop.asm"
