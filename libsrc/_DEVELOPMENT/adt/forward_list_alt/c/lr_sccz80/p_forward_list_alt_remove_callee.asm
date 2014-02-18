
; void *p_forward_list_alt_remove(p_forward_list_alt_t *list, void *item)

XDEF asm_p_forward_list_alt_remove_callee

p_forward_list_alt_remove_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_p_forward_list_alt_remove.asm"
