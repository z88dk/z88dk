
; void p_stack_init(void *p)

SECTION seg_code_p_stack

PUBLIC _p_stack_init

EXTERN _p_forward_list_init

defc _p_stack_init = _p_forward_list_init

INCLUDE "adt/p_stack/z80/asm_p_stack_init.asm"
