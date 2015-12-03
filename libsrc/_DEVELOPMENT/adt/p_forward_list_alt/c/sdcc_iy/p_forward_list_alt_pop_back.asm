
; void *p_forward_list_alt_pop_back(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_pop_back

EXTERN asm_p_forward_list_alt_pop_back

_p_forward_list_alt_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_forward_list_alt_pop_back
