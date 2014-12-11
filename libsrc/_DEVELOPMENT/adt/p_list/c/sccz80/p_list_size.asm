
; size_t p_list_size(p_list_t *list)

SECTION code_adt_p_list

PUBLIC p_list_size

defc p_list_size = asm_p_list_size

INCLUDE "adt/p_list/z80/asm_p_list_size.asm"
