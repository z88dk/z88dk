
; void *p_list_remove_after(p_list_t *list, void *list_item)

XDEF p_list_remove_after

p_list_remove_after:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_p_list_remove_after.asm"
