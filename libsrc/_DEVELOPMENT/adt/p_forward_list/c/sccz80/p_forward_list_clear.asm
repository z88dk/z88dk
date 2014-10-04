
; void p_forward_list_clear(p_forward_list_t *list)

SECTION seg_code_p_forward_list

PUBLIC p_forward_list_clear

defc p_forward_list_clear = asm_p_forward_list_clear

INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_clear.asm"
