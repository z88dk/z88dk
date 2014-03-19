
; void *p_stack_pop(p_stack_t *s)

XDEF p_stack_pop

LIB p_forward_list_remove_after

defc p_stack_pop = p_forward_list_remove_after

INCLUDE "../../z80/asm_p_stack_pop.asm"
