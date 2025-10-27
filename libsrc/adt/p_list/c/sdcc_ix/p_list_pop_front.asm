
; void *p_list_pop_front(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_pop_front

EXTERN asm_p_list_pop_front

_p_list_pop_front:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_list_pop_front
