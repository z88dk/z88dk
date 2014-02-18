
; void p_forward_list_alt_push_back(p_forward_list_alt_t *list, void *item)

XDEF p_forward_list_alt_push_back
XDEF p_queue_push

p_forward_list_alt_push_back:
p_queue_push:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_alt_push_back.asm"
