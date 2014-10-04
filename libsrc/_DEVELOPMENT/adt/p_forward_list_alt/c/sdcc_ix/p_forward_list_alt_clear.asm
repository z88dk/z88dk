
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)

SECTION seg_code_p_forward_list_alt

PUBLIC _p_forward_list_alt_clear

EXTERN _p_forward_list_alt_init

defc _p_forward_list_alt_clear = _p_forward_list_alt_init

INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_clear.asm"
