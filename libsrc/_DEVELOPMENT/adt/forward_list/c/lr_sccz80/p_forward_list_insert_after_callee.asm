
; void *p_forward_list_insert_after(void *list_item, void *item)

XDEF p_forward_list_insert_after_callee
XDEF p_forward_list_push_front_callee, p_stack_push_callee

p_forward_list_insert_after_callee:
p_forward_list_push_front_callee:
p_stack_push_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_p_forward_list_insert_after.asm"
