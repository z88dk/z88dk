
; void *p_list_push_front(p_list_t *list, void *item)

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
