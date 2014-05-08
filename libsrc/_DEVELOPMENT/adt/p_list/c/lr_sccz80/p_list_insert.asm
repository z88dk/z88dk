
; void *p_list_insert(p_list_t *list, void *list_item, void *item)

PUBLIC p_list_insert

EXTERN asm_p_list_insert

p_list_insert:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm_p_list_insert
