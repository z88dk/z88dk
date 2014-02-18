
; void p_forward_list_push_back(p_forward_list_t *list, void *item)

XDEF p_forward_list_push_back_callee

p_forward_list_push_back_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_p_forward_list_push_back.asm"
