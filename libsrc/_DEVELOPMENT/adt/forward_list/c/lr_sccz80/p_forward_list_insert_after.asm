
; void *p_forward_list_insert_after(void *list_item, void *item)

XLIB p_forward_list_insert_after
XDEF p_forward_list_push_front, p_stack_push

LIB asm_p_forward_list_insert_after

p_forward_list_insert_after:
p_forward_list_push_front:
p_stack_push:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_p_forward_list_insert_after
