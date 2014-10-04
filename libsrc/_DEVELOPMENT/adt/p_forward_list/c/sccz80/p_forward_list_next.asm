
; void *p_forward_list_next(void *item)

SECTION seg_code_p_forward_list

PUBLIC p_forward_list_next

defc p_forward_list_next = asm_p_forward_list_next

INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_next.asm"
