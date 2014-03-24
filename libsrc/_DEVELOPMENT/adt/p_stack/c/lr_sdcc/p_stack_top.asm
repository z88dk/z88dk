
; void *p_stack_top(p_stack_t *s)

XDEF p_stack_top

LIB p_forward_list_front

defc p_stack_top = p_forward_list_front

INCLUDE "adt/p_stack/z80/asm_p_stack_top.asm"
