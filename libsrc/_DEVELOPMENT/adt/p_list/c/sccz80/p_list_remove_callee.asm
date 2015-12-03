
; void *p_list_remove(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_remove_callee

EXTERN asm_p_list_remove

p_list_remove_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_p_list_remove
