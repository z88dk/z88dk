
; void *p_list_next_fastcall(void *item)

SECTION code_adt_p_list

PUBLIC _p_list_next_fastcall

defc p_list_next_fastcall = asm_p_list_next

INCLUDE "adt/p_list/z80/asm_p_list_next.asm"
