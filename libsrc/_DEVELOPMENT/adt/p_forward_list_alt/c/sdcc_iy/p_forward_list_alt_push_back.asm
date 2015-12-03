
; void p_forward_list_alt_push_back(p_forward_list_alt_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_push_back

EXTERN asm_p_forward_list_alt_push_back

_p_forward_list_alt_push_back:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_p_forward_list_alt_push_back
