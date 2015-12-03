
; void p_stack_init_fastcall(void *p)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_init_fastcall

EXTERN asm_p_stack_init

defc _p_stack_init_fastcall = asm_p_stack_init
