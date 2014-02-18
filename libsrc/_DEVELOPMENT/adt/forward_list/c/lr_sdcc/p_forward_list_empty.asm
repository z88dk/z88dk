
; int p_forward_list_empty(p_forward_list_t *list)

XDEF p_forward_list_empty
XDEF p_forward_list_alt_empty, p_list_empty, p_stack_empty, p_queue_empty

p_forward_list_empty:
p_forward_list_alt_empty:
p_list_empty:
p_stack_empty:
p_queue_empty:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_forward_list_empty.asm"
