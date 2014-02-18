
; void p_forward_list_alt_push_back(p_forward_list_alt_t *list, void *item)

XDEF p_forward_list_alt_push_back
XDEF p_queue_push

p_forward_list_alt_push_back:
p_queue_push:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_alt_push_back.asm"
