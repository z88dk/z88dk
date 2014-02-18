
; void *p_list_remove(p_list_t *list, void *item)

XDEF p_list_remove

p_list_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_p_list_remove.asm"
