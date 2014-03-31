
; void *p_list_push_back(p_list_t *list, void *item)

XDEF p_list_push_back

p_list_push_back:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   INCLUDE "adt/p_list/z80/asm_p_list_push_back.asm"
