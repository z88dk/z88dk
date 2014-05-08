
; void *p_list_insert_after(p_list_t *list, void *list_item, void *item)

PUBLIC _p_list_insert_after

_p_list_insert_after:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_insert_after.asm"
