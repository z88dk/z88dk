
; void *p_list_insert_after(p_list_t *list, void *list_item, void *item)

SECTION seg_code_p_list

PUBLIC asm_p_list_insert_after_callee

p_list_insert_after_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_insert_after.asm"
