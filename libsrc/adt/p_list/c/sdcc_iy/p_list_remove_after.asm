
; void *p_list_remove_after(p_list_t *list, void *list_item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_remove_after

EXTERN asm_p_list_remove_after

_p_list_remove_after:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_p_list_remove_after
