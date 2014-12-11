
; void *p_list_next(void *item)

SECTION code_adt_p_list

PUBLIC p_list_next

defc p_list_next = asm_p_list_next

INCLUDE "adt/p_list/z80/asm_p_list_next.asm"
