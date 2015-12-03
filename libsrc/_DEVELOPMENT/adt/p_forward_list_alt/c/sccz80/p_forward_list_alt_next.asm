
; void *p_forward_list_alt_next(void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_next

EXTERN asm_p_forward_list_alt_next

defc p_forward_list_alt_next = asm_p_forward_list_alt_next
