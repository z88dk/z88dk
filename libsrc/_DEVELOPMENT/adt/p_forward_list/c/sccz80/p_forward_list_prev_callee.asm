
; void *p_forward_list_prev(forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_prev_callee

EXTERN asm_p_forward_list_prev

p_forward_list_prev_callee:

   pop hl
   pop bc
   ex (sp),hl

   jp asm_p_forward_list_prev
