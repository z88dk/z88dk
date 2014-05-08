
; void *p_list_remove(p_list_t *list, void *item)

PUBLIC _p_list_remove

_p_list_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_remove.asm"
