
; void *p_forward_list_alt_prev(forward_list_alt_t *list, void *item)

SECTION seg_code_p_forward_list_alt

PUBLIC p_forward_list_alt_prev

EXTERN p_forward_list_prev

defc p_forward_list_alt_prev = p_forward_list_prev

INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_prev.asm"
