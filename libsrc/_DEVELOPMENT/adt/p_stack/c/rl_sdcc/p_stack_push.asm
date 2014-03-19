
; void p_stack_push(p_stack_t *s, void *item)

XDEF p_stack_push

LIB p_forward_list_insert_after

defc p_stack_push = p_forward_list_insert_after

INCLUDE "../../z80/asm_p_stack_push.asm"
