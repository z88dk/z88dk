
; void *p_forward_list_alt_remove_callee(p_forward_list_alt_t *list, void *item)

SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_remove_callee

_p_forward_list_alt_remove_callee:

   pop af
   pop hl
   pop bc
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_remove.asm"
