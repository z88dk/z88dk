
; void p_forward_list_alt_init_fastcall(void *p)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_init_fastcall

EXTERN asm_p_forward_list_alt_init

defc _p_forward_list_alt_init_fastcall = asm_p_forward_list_alt_init
