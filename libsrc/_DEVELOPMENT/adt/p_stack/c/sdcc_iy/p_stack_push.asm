
; void p_stack_push(p_stack_t *s, void *item)

XDEF _p_stack_push

LIB _p_forward_list_insert_after

_p_stack_push:

   jp _p_forward_list_insert_after

   INCLUDE "adt/p_stack/z80/asm_p_stack_push.asm"
