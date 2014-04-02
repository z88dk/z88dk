
; int p_stack_empty(p_stack_t *s)

XDEF _p_stack_empty

LIB _p_forward_list_empty

_p_stack_empty:

   jp _p_forward_list_empty

   INCLUDE "adt/p_stack/z80/asm_p_stack_empty.asm"
