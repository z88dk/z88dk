
; void *p_forward_list_alt_back(p_forward_list_alt_t *list)

XDEF p_forward_list_alt_back
XDEF p_queue_back

p_forward_list_alt_back:
p_queue_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_forward_list_alt_back.asm"
