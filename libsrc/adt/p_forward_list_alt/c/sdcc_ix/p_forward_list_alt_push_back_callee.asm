
; void p_forward_list_alt_push_back_callee(p_forward_list_alt_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_push_back_callee

EXTERN asm_p_forward_list_alt_push_back

_p_forward_list_alt_push_back_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_p_forward_list_alt_push_back
