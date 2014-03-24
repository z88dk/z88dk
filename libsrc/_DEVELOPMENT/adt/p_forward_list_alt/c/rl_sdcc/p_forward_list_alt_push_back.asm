
; void p_forward_list_alt_push_back(p_forward_list_alt_t *list, void *item)

XDEF p_forward_list_alt_push_back

p_forward_list_alt_push_back:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_push_back.asm"
