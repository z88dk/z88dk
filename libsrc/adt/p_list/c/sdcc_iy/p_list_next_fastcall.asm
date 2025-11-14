
; void *p_list_next_fastcall(void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_next_fastcall

EXTERN asm_p_list_next

defc _p_list_next_fastcall = asm_p_list_next
