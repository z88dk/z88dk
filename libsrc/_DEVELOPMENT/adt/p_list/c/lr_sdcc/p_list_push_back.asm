
; void *p_list_push_back(p_list_t *list, void *item)

XDEF p_list_push_back

p_list_push_back:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   INCLUDE "adt/p_list/z80/asm_p_list_push_back.asm"
