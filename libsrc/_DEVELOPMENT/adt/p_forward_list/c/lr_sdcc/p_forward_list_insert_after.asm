
; void *p_forward_list_insert_after(void *list_item, void *item)

XDEF p_forward_list_insert_after
XDEF p_forward_list_push_front, p_stack_push

p_forward_list_insert_after:
p_forward_list_push_front:
p_stack_push:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_insert_after.asm"
