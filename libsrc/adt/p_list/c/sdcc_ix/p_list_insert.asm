
; void *p_list_insert(p_list_t *list, void *list_item, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_insert

EXTERN asm_p_list_insert

_p_list_insert:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_p_list_insert
