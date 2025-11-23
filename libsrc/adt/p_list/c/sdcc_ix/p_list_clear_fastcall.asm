
; void p_list_clear_fastcall(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_clear_fastcall

EXTERN asm_p_list_clear

defc _p_list_clear_fastcall = asm_p_list_clear
