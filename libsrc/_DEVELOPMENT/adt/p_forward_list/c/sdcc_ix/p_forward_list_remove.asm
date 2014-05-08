
; void *p_forward_list_remove(p_forward_list_t *list, void *item)

PUBLIC _p_forward_list_remove

_p_forward_list_remove:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_remove.asm"
