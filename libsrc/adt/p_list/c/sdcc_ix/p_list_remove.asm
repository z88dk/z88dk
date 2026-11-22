
; void *p_list_remove(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_remove

EXTERN asm_p_list_remove

_p_list_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_p_list_remove
