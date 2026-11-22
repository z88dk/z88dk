
; void *p_list_pop_back(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_pop_back

EXTERN asm_p_list_pop_back

_p_list_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_list_pop_back
