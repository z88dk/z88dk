
; void *p_list_push_front(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_push_front

EXTERN asm_p_list_push_front

_p_list_push_front:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm_p_list_push_front
