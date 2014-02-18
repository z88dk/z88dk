
; size_t p_forward_list_size(p_forward_list_t *list)

XDEF p_forward_list_size
XDEF p_forward_list_alt_size, p_list_size, p_stack_size, p_queue_size

p_forward_list_size:
p_forward_list_alt_size:
p_list_size:
p_stack_size:
p_queue_size:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_forward_list_size.asm"
