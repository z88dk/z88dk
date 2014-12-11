
; void p_forward_list_push_back(p_forward_list_t *list, void *item)

SECTION code_adt_p_forward_list

PUBLIC p_forward_list_push_back_callee

p_forward_list_push_back_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_push_back.asm"
