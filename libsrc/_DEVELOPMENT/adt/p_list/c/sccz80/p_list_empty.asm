
; int p_list_empty(p_list_t *list)

SECTION code_adt_p_list

PUBLIC p_list_empty

defc p_list_empty = asm_p_list_empty

INCLUDE "adt/p_list/z80/asm_p_list_empty.asm"
