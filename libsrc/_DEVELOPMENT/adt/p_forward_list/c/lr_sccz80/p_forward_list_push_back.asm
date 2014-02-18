
; void p_forward_list_push_back(p_forward_list_t *list, void *item)

XLIB p_forward_list_push_back

LIB asm_p_forward_list_push_back

p_forward_list_push_back:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_p_forward_list_push_back
