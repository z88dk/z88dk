
; void *p_list_push_front(p_list_t *list, void *item)

PUBLIC _p_list_push_front

_p_list_push_front:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   INCLUDE "adt/p_list/z80/asm_p_list_push_front.asm"
