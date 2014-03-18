
; size_t p_forward_list_size(p_forward_list_t *list)

XDEF p_forward_list_size

p_forward_list_size:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_forward_list_size.asm"
