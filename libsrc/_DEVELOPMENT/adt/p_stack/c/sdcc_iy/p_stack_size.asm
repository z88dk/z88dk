
; size_t p_stack_size(p_stack_t *s)

PUBLIC _p_stack_size

EXTERN _p_forward_list_size

_p_stack_size:

   jp _p_forward_list_size

   INCLUDE "adt/p_stack/z80/asm_p_stack_size.asm"
