
; void p_list_clear(p_list_t *list)

SECTION seg_code_p_list

PUBLIC _p_list_clear

EXTERN _p_list_init

defc _p_list_clear = _p_list_init

INCLUDE "adt/p_list/z80/asm_p_list_clear.asm"
