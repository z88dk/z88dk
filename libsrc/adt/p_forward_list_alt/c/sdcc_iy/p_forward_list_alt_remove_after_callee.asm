
; void *p_forward_list_alt_remove_after_callee(p_forward_list_alt_t *list, void *list_item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_remove_after_callee

EXTERN asm_p_forward_list_alt_remove_after

_p_forward_list_alt_remove_after_callee:

   pop hl
   pop bc
   ex (sp),hl

   jp asm_p_forward_list_alt_remove_after
