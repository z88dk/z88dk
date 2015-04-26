
; void *p_list_insert_after_callee(p_list_t *list, void *list_item, void *item)

SECTION code_adt_p_list

PUBLIC _p_list_insert_after_callee

_p_list_insert_after_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_insert_after.asm"
