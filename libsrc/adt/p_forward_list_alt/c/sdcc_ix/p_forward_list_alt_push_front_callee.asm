
; void p_forward_list_alt_push_front_callee(p_forward_list_alt_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_push_front_callee

EXTERN asm_p_forward_list_alt_push_front

_p_forward_list_alt_push_front_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_p_forward_list_alt_push_front
