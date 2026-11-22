
; void p_forward_list_push_back(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_push_back

EXTERN asm_p_forward_list_push_back

_p_forward_list_push_back:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_p_forward_list_push_back
