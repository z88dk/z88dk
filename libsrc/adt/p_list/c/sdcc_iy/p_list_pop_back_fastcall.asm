
; void *p_list_pop_back_fastcall(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_pop_back_fastcall

EXTERN asm_p_list_pop_back

defc _p_list_pop_back_fastcall = asm_p_list_pop_back
