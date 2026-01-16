
; size_t p_list_size_fastcall(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_size_fastcall

EXTERN asm_p_list_size

defc _p_list_size_fastcall = asm_p_list_size
