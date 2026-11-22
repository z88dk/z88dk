
; void *p_list_prev_fastcall(void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_prev_fastcall

EXTERN asm_p_list_prev

defc _p_list_prev_fastcall = asm_p_list_prev
