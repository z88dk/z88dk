
; void p_forward_list_alt_push_front(p_forward_list_alt_t *list, void *item)

XLIB p_forward_list_alt_push_front

LIB asm_p_forward_list_alt_push_front

p_forward_list_alt_push_front:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_p_forward_list_alt_push_front
