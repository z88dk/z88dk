
; void *p_list_remove_after_callee(p_list_t *list, void *list_item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_remove_after_callee

EXTERN asm_p_list_remove_after

_p_list_remove_after_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_p_list_remove_after
