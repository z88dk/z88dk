
; void *p_list_pop_back(p_list_t *list)

XDEF p_list_pop_back

p_list_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_list_pop_back.asm"
