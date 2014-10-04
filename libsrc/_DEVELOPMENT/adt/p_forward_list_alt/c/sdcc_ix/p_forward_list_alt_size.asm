
; size_t p_forward_list_alt_size(p_forward_list_alt_t *list)

SECTION seg_code_p_forward_list_alt

PUBLIC _p_forward_list_alt_size

EXTERN _p_forward_list_size

defc _p_forward_list_alt_size = _p_forward_list_size

INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_size.asm"
