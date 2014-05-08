
; void *p_forward_list_pop_back(p_forward_list_t *list)

PUBLIC _p_forward_list_pop_back

_p_forward_list_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_pop_back.asm"
