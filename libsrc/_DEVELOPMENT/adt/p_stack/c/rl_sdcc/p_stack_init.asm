
; void p_stack_init(void *p)

XDEF p_stack_init

LIB p_forward_list_init

defc p_stack_init = p_forward_list_init

INCLUDE "adt/p_stack/z80/asm_p_stack_init.asm"
