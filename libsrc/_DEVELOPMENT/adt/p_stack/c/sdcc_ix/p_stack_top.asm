
; void *p_stack_top(p_stack_t *s)

XDEF _p_stack_top

LIB _p_forward_list_front

_p_stack_top:

   jp _p_forward_list_front

   INCLUDE "adt/p_stack/z80/asm_p_stack_top.asm"
