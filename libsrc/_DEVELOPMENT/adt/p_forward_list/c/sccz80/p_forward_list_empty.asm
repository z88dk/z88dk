
; int p_forward_list_empty(p_forward_list_t *list)

SECTION seg_code_p_forward_list

PUBLIC p_forward_list_empty

defc p_forward_list_empty = asm_p_forward_list_empty

INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_empty.asm"
