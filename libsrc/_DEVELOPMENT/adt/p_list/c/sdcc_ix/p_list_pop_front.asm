
; void *p_list_pop_front(p_list_t *list)

PUBLIC _p_list_pop_front

_p_list_pop_front:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_list/z80/asm_p_list_pop_front.asm"
