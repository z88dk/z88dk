
; void *p_forward_list_remove(p_forward_list_t *list, void *item)

PUBLIC p_forward_list_remove_callee

p_forward_list_remove_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_remove.asm"
