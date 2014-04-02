
; void *p_stack_pop(p_stack_t *s)

XDEF _p_stack_pop

LIB _p_forward_list_remove_after

_p_stack_pop:

   jp _p_forward_list_remove_after

   INCLUDE "adt/p_stack/z80/asm_p_stack_pop.asm"
