
; size_t p_forward_list_size_fastcall(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_size_fastcall

EXTERN asm_p_forward_list_size

defc _p_forward_list_size_fastcall = asm_p_forward_list_size
