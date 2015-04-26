
; void *p_forward_list_alt_remove_after_callee(p_forward_list_alt_t *list, void *list_item)

SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_remove_after_callee

_p_forward_list_alt_remove_after_callee:

   pop hl
   pop bc
   ex (sp),hl

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_remove_after.asm"
