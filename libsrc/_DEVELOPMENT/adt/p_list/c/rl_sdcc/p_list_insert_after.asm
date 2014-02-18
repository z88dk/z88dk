
; void *p_list_insert_after(p_list_t *list, void *list_item, void *item)

XDEF p_list_insert_after

p_list_insert_after:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_p_list_insert_after.asm"
