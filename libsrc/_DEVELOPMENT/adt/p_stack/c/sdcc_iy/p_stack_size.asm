
; size_t p_stack_size(p_stack_t *s)

XDEF p_stack_size

LIB p_forward_list_size

p_stack_size:

   jp p_forward_list_size

   INCLUDE "adt/p_stack/z80/asm_p_stack_size.asm"
