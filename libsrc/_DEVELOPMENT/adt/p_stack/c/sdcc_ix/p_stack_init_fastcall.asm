
; void p_stack_init_fastcall(void *p)

SECTION code_adt_p_stack

PUBLIC _p_stack_init_fastcall

defc _p_stack_init_fastcall = asm_p_stack_init

INCLUDE "adt/p_stack/z80/asm_p_stack_init.asm"
