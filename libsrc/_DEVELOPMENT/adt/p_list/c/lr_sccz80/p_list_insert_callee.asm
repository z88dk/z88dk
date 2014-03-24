
; void *p_list_insert(p_list_t *list, void *list_item, void *item)

XDEF p_list_insert_callee

p_list_insert_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_insert.asm"
