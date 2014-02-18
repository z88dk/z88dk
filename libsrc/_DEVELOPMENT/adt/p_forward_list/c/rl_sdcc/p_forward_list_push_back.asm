
; void p_forward_list_push_back(p_forward_list_t *list, void *item)

XDEF p_forward_list_push_back

p_forward_list_push_back:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_p_forward_list_push_back.asm"
