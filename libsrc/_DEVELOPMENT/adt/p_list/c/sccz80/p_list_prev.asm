
; void *p_list_prev(void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_prev

EXTERN asm_p_list_prev

defc p_list_prev = asm_p_list_prev
