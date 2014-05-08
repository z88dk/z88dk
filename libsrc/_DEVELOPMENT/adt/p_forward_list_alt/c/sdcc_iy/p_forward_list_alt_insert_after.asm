
; void *p_forward_list_alt_insert_after(p_forward_list_alt_t *list, void *list_item, void *item)

PUBLIC _p_forward_list_alt_insert_after

_p_forward_list_alt_insert_after:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_insert_after.asm"
