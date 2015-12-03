
; void *p_list_push_front(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_push_front

EXTERN asm_p_list_push_front

p_list_push_front:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_p_list_push_front
