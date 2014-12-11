
; void *p_forward_list_alt_prev(forward_list_t *list, void *item)

SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_prev_callee

EXTERN p_forward_list_prev_callee

defc p_forward_list_alt_prev_callee = p_forward_list_prev_callee

INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_prev.asm"
