
; void *p_forward_list_next(void *item)

SECTION seg_code_p_forward_list

PUBLIC _p_forward_list_next

EXTERN _p_forward_list_front

defc _p_forward_list_next = _p_forward_list_front

INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_next.asm"
