
; void *p_forward_list_alt_next_fastcall(void *item)

SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_next_fastcall

defc _p_forward_list_alt_next_fastcall = asm_p_forward_list_alt_next

INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_next.asm"
