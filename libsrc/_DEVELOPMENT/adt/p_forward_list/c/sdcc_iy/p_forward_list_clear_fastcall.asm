
; void p_forward_list_clear_fastcall(p_forward_list_t *list)

SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_clear_fastcall

defc _p_forward_list_clear_fastcall = asm_p_forward_list_clear

INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_clear.asm"
