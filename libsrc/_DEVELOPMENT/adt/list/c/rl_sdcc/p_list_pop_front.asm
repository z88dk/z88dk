
; void *p_list_pop_front(p_list_t *list)

XDEF p_list_pop_front

p_list_pop_front:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_list_pop_front.asm"
