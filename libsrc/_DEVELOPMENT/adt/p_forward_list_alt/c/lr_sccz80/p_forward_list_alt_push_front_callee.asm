
; void p_forward_list_alt_push_front(p_forward_list_alt_t *list, void *item)

XDEF p_forward_list_alt_push_front_callee

p_forward_list_alt_push_front_callee:

   pop af
   pop de
   pop bc
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_alt_push_front.asm"
