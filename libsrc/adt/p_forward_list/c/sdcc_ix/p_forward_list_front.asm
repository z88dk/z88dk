
; void *p_forward_list_front(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_front

EXTERN asm_p_forward_list_front

_p_forward_list_front:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_forward_list_front
