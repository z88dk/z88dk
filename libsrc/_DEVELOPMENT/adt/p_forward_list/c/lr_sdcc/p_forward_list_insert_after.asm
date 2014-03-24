
; void *p_forward_list_insert_after(void *list_item, void *item)

XDEF p_forward_list_insert_after

p_forward_list_insert_after:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_insert_after.asm"
