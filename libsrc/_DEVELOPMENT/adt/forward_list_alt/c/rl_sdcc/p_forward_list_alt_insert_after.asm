
; void *p_forward_list_alt_insert_after(p_forward_list_alt_t *list, void *list_item, void *item)

XDEF p_forward_list_alt_insert_after

p_forward_list_alt_insert_after:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

   INCLUDE "../../z80/asm_p_forward_list_alt_insert_after.asm"
