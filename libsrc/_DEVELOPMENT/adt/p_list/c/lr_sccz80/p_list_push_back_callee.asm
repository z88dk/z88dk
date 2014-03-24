
; void *p_list_push_back(p_list_t *list, void *item)

XDEF p_list_push_back_callee

p_list_push_back_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "adt/p_list/z80/asm_p_list_push_back.asm"
