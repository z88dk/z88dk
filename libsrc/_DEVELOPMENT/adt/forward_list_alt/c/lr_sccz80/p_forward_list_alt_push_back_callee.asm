
; void p_forward_list_alt_push_back(p_forward_list_alt_t *list, void *item)

XDEF p_forward_list_alt_push_back_callee
XDEF p_queue_push_callee

p_forward_list_alt_push_back_callee:
p_queue_push_callee:

   pop af
   pop de
   pop bc
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_alt_push_back.asm"
