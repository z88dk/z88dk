
; void p_forward_list_push_back_callee(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_push_back_callee

EXTERN asm_p_forward_list_push_back

_p_forward_list_push_back_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_p_forward_list_push_back
