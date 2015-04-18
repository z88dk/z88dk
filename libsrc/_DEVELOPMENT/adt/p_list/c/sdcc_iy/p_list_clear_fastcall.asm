
; void p_list_clear_fastcall(p_list_t *list)

SECTION code_adt_p_list

PUBLIC _p_list_clear_fastcall

defc _p_list_clear = asm_p_list_clear

INCLUDE "adt/p_list/z80/asm_p_list_clear.asm"
