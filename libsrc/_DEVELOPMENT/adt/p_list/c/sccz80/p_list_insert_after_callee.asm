
; void *p_list_insert_after(p_list_t *list, void *list_item, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_insert_after_callee

EXTERN asm_p_list_insert_after

p_list_insert_after_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_p_list_insert_after
