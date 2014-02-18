
; void *p_forward_list_back(p_forward_list_t *list)

XDEF p_forward_list_back

p_forward_list_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_forward_list_back.asm"
