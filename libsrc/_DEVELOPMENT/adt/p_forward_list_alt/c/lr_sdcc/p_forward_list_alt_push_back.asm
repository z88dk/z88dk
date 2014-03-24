
; void p_forward_list_alt_push_back(p_forward_list_alt_t *list, void *item)

XDEF p_forward_list_alt_push_back

p_forward_list_alt_push_back:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_push_back.asm"
