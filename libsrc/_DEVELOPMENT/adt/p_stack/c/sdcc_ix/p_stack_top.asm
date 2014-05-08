
; void *p_stack_top(p_stack_t *s)

PUBLIC _p_stack_top

EXTERN _p_forward_list_front

_p_stack_top:

   jp _p_forward_list_front

   INCLUDE "adt/p_stack/z80/asm_p_stack_top.asm"
