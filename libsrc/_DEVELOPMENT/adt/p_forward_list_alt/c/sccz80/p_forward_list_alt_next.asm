
; void *p_forward_list_alt_next(void *item)

SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_next

defc p_forward_list_alt_next = asm_p_forward_list_alt_next

INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_next.asm"
