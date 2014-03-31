
; void *p_list_insert(p_list_t *list, void *list_item, void *item)

XDEF p_list_insert

p_list_insert:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_insert.asm"
