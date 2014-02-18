
; void *p_list_push_back(p_list_t *list, void *item)

XLIB p_list_push_back

LIB asm_p_list_push_back

p_list_push_back:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_p_list_push_back
