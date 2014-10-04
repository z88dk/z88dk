
; void p_list_clear(p_list_t *list)

SECTION seg_code_p_list

PUBLIC p_list_clear

defc p_list_clear = asm_p_list_clear

INCLUDE "adt/p_list/z80/asm_p_list_clear.asm"
