
; void *p_forward_list_front(p_forward_list_t *list)

XDEF p_forward_list_front

p_forward_list_front:

   pop af
   pop hl
   
   push hl
   push af
   
   jr asm_p_forward_list_front

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_front.asm"
