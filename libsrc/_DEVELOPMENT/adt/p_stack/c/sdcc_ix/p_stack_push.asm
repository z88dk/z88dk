
; void p_stack_push(p_stack_t *s, void *item)

PUBLIC _p_stack_push

EXTERN _p_forward_list_insert_after

_p_stack_push:

   jp _p_forward_list_insert_after

   INCLUDE "adt/p_stack/z80/asm_p_stack_push.asm"
