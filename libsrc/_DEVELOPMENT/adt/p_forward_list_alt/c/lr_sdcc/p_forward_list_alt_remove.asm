
; void *p_forward_list_alt_remove(p_forward_list_alt_t *list, void *item)

XDEF p_forward_list_alt_remove

p_forward_list_alt_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_remove.asm"
