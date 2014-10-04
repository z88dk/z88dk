
; void *p_forward_list_prev(forward_list_t *list, void *item)

SECTION seg_code_p_forward_list

PUBLIC p_forward_list_prev_callee

p_forward_list_prev_callee:

   pop hl
   pop bc
   ex (sp),hl

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_prev.asm"
