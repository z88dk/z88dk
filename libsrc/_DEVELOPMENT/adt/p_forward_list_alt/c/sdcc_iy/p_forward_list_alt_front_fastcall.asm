
; void *p_forward_list_alt_front_fastcall(p_forward_list_alt_t *list)

SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_front_fastcall

defc _p_forward_list_alt_front_fastcall = asm_p_forward_list_alt_front

INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_front.asm"
