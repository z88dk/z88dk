
; void p_forward_list_init(void *p)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_init

EXTERN asm_p_forward_list_init

defc p_forward_list_init = asm_p_forward_list_init
