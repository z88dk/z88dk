
; void *p_forward_list_next(void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_next

EXTERN asm_p_forward_list_next

defc p_forward_list_next = asm_p_forward_list_next
