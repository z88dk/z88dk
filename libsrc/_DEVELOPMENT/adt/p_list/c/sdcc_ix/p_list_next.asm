
; void *p_list_next(void *item)

SECTION seg_code_p_list

PUBLIC _p_list_next

EXTERN _p_forward_list_next

defc p_list_next = _p_forward_list_next

INCLUDE "adt/p_list/z80/asm_p_list_next.asm"
