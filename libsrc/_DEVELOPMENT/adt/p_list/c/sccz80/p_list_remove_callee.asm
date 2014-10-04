
; void *p_list_remove(p_list_t *list, void *item)

SECTION seg_code_p_list

PUBLIC p_list_remove_callee

p_list_remove_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_remove.asm"
