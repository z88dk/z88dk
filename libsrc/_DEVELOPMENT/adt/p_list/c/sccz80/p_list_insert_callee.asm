
; void *p_list_insert(p_list_t *list, void *list_item, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_insert_callee

EXTERN asm_p_list_insert

p_list_insert_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_p_list_insert
