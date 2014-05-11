
; void p_forward_list_alt_push_front(p_forward_list_alt_t *list, void *item)

PUBLIC p_forward_list_alt_push_front_callee

p_forward_list_alt_push_front_callee:

   pop af
   pop de
   pop bc
   push af
   
   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_push_front.asm"
