
; void *p_list_remove(p_list_t *list, void *item)

XDEF p_list_remove

p_list_remove:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_remove.asm"
