
; void p_list_init(void *p)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_init

EXTERN asm_p_list_init

defc p_list_init = asm_p_list_init
