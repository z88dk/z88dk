
; void p_forward_list_alt_push_back(p_forward_list_alt_t *list, void *item)

XLIB p_forward_list_alt_push_back
XDEF p_queue_push

LIB asm_p_forward_list_alt_push_back

p_forward_list_alt_push_back:
p_queue_push:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_p_forward_list_alt_push_back
