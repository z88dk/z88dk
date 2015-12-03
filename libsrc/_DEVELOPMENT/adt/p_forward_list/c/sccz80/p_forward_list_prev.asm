
; void *p_forward_list_prev(forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_prev

EXTERN asm_p_forward_list_prev

p_forward_list_prev:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_p_forward_list_prev
