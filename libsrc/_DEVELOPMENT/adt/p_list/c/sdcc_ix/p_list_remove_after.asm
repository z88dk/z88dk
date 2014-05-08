
; void *p_list_remove_after(p_list_t *list, void *list_item)

PUBLIC _p_list_remove_after

_p_list_remove_after:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_remove_after.asm"
