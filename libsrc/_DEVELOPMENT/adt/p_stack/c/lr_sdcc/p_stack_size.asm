
; size_t p_stack_size(p_stack_t *s)

XDEF p_stack_size

LIB p_forward_list_size

defc p_stack_size = p_forward_list_size

INCLUDE "../../z80/asm_p_stack_size.asm"
