
; void *p_forward_list_alt_remove(p_forward_list_alt_t *list, void *item)

XDEF _p_forward_list_alt_remove

_p_forward_list_alt_remove:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_remove.asm"
