
; void *p_forward_list_alt_insert_after(p_forward_list_alt_t *list, void *list_item, void *item)

XLIB p_forward_list_alt_insert_after

LIB asm_p_forward_list_alt_insert_after

p_forward_list_alt_insert_after:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af

   jp asm_p_forward_list_alt_insert_after
