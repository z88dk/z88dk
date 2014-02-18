
; void *p_list_remove_after(p_list_t *list, void *list_item)

XLIB p_list_remove_after

LIB asm_p_list_remove_after

p_list_remove_after:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_p_list_remove_after
