
; void *p_forward_list_alt_insert_after_callee(p_forward_list_alt_t *list, void *list_item, void *item)

SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_insert_after_callee

_p_forward_list_alt_insert_after_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_insert_after.asm"
