
; void *p_forward_list_alt_remove(p_forward_list_alt_t *list, void *item)

XDEF asm_p_forward_list_alt_remove

p_forward_list_alt_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   INCLUDE "../../z80/asm_p_forward_list_alt_remove.asm"
