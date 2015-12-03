
; void p_stack_init(void *p)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC p_stack_init

EXTERN asm_p_stack_init

defc p_stack_init = asm_p_stack_init
