
; void *p_list_push_back(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_push_back

EXTERN asm_p_list_push_back

_p_list_push_back:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm_p_list_push_back
