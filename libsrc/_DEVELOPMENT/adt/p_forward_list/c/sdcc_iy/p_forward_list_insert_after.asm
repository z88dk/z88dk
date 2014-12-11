
; void *p_forward_list_insert_after(void *list_item, void *item)

SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_insert_after

_p_forward_list_insert_after:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_insert_after.asm"
