
; void *p_list_remove_after_callee(p_list_t *list, void *list_item)

SECTION code_adt_p_list

PUBLIC _p_list_remove_after_callee

_p_list_remove_after_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/p_list/z80/asm_p_list_remove_after.asm"
