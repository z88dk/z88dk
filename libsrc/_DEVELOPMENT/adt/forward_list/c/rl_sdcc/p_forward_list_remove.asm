
; void *p_forward_list_remove(p_forward_list_t *list, void *item)

XDEF p_forward_list_remove

p_forward_list_remove:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_remove.asm"
