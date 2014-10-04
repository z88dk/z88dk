
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)

SECTION seg_code_p_forward_list_alt

PUBLIC p_forward_list_alt_clear

defc p_forward_list_alt_clear = asm_p_forward_list_alt_clear

INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_clear.asm"
