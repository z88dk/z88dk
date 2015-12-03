
; void *p_forward_list_pop_back(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_pop_back

EXTERN asm_p_forward_list_pop_back

_p_forward_list_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_forward_list_pop_back
