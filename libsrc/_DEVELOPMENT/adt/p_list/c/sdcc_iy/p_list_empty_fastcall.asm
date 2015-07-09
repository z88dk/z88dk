
; int p_list_empty_fastcall(p_list_t *list)

SECTION code_adt_p_list

PUBLIC _p_list_empty_fastcall

EXTERN asm_p_list_empty

defc _p_list_empty = asm_p_list_empty
