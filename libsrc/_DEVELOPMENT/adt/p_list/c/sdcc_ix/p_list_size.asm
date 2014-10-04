
; size_t p_list_size(p_list_t *list)

SECTION seg_code_p_list

PUBLIC _p_list_size

EXTERN _p_forward_list_size

defc _p_list_size = _p_forward_list_size

INCLUDE "adt/p_list/z80/asm_p_list_size.asm"
