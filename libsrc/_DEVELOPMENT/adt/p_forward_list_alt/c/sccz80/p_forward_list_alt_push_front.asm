
; void p_forward_list_alt_push_front(p_forward_list_alt_t *list, void *item)

SECTION seg_code_p_forward_list_alt

PUBLIC p_forward_list_alt_push_front

EXTERN asm_p_forward_list_alt_push_front

p_forward_list_alt_push_front:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_p_forward_list_alt_push_front
