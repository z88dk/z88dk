
; void p_stack_init(void *p)

XDEF _p_stack_init

LIB _p_forward_list_init

_p_stack_init:

   jp _p_forward_list_init

   INCLUDE "adt/p_stack/z80/asm_p_stack_init.asm"
