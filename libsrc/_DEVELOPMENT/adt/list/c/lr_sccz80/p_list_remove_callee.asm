
; void *p_list_remove(p_list_t *list, void *item)

XDEF p_list_remove_callee

p_list_remove_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "../../z80/asm_p_list_remove.asm"
