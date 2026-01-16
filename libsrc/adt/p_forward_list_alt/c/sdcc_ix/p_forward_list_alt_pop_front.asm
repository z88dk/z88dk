
; void *p_forward_list_alt_pop_front(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_pop_front

EXTERN asm_p_forward_list_alt_pop_front

_p_forward_list_alt_pop_front:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_forward_list_alt_pop_front
