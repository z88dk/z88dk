
; void *p_forward_list_remove_callee(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_remove_callee

EXTERN asm_p_forward_list_remove

_p_forward_list_remove_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_p_forward_list_remove
