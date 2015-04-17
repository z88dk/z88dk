
; void *p_forward_list_next_fastcall(void *item)

SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_next_fastcall

defc _p_forward_list_next = asm_p_forward_list_next

INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_next.asm"
