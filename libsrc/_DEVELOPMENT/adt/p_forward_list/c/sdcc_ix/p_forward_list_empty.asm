
; int p_forward_list_empty(p_forward_list_t *list)

XDEF _p_forward_list_empty

_p_forward_list_empty:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_empty.asm"
