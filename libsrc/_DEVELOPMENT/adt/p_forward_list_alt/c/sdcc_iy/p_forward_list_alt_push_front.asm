
; void p_forward_list_alt_push_front(p_forward_list_alt_t *list, void *item)

PUBLIC _p_forward_list_alt_push_front

_p_forward_list_alt_push_front:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_push_front.asm"
