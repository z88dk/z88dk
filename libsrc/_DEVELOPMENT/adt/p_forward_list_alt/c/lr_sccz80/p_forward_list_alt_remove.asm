
; void *p_forward_list_alt_remove(p_forward_list_alt_t *list, void *item)

XLIB asm_p_forward_list_alt_remove

LIB asm_p_forward_list_alt_remove

p_forward_list_alt_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   jp asm_p_forward_list_alt_remove
