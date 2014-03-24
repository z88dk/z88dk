
; void p_forward_list_push_back(p_forward_list_t *list, void *item)

XDEF p_forward_list_push_back

p_forward_list_push_back:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_push_back.asm"
