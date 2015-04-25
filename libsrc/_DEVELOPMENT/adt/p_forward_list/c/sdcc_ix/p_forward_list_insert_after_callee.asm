
; void *p_forward_list_insert_after_callee(void *list_item, void *item)

SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_insert_after_callee

_p_forward_list_insert_after_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_insert_after.asm"
