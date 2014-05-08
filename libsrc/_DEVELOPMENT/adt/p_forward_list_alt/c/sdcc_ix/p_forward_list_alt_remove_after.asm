
; void *p_forward_list_alt_remove_after(p_forward_list_alt_t *list, void *list_item)

PUBLIC _p_forward_list_alt_remove_after

_p_forward_list_alt_remove_after:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_remove_after.asm"
