
; void p_list_init_fastcall(void *p)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_init_fastcall

EXTERN asm_p_list_init

defc _p_list_init_fastcall = asm_p_list_init
