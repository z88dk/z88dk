
; void *p_forward_list_alt_remove_after(p_forward_list_alt_t *list, void *list_item)

XDEF p_forward_list_alt_remove_after_callee

p_forward_list_alt_remove_after_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_alt_remove_after.asm"
