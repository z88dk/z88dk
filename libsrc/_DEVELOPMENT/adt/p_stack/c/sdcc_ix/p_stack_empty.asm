
; int p_stack_empty(p_stack_t *s)

XDEF p_stack_empty

LIB p_forward_list_empty

p_stack_empty:

   jp p_forward_list_empty

   INCLUDE "adt/p_stack/z80/asm_p_stack_empty.asm"
