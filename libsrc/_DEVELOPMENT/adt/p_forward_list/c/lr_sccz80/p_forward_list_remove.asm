
; void *p_forward_list_remove(p_forward_list_t *list, void *item)

XLIB p_forward_list_remove

LIB asm_p_forward_list_remove

p_forward_list_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_p_forward_list_remove
