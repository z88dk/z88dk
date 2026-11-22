
; void *p_list_push_back_callee(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_push_back_callee

EXTERN asm_p_list_push_back

_p_list_push_back_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_p_list_push_back
