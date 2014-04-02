
; void *p_list_back(p_list_t *list)

XDEF _p_list_back

_p_list_back:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_p_list_back

   INCLUDE "adt/p_list/z80/asm_p_list_back.asm"
