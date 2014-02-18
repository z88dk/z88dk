
; void *p_forward_list_remove_after(void *list_item)

XDEF p_forward_list_remove_after
XDEF p_forward_list_pop_front, p_stack_pop

p_forward_list_remove_after:
p_forward_list_pop_front:
p_stack_pop:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_forward_list_remove_after.asm"
