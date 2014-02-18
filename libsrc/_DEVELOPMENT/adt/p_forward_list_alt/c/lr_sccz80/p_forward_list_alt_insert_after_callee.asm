
; void *p_forward_list_alt_insert_after(p_forward_list_alt_t *list, void *list_item, void *item)

XDEF p_forward_list_alt_insert_after_callee

p_forward_list_alt_insert_after_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_alt_insert_after.asm"
