
; void *p_list_front(p_list_t *list)

SECTION seg_code_p_list

PUBLIC p_list_front

defc p_list_front = asm_p_list_front

INCLUDE "adt/p_list/z80/asm_p_list_front.asm"
