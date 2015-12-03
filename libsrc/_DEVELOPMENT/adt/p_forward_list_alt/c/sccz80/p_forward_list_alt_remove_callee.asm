
; void *p_forward_list_alt_remove(p_forward_list_alt_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_remove_callee

EXTERN asm_p_forward_list_alt_remove

p_forward_list_alt_remove_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_p_forward_list_alt_remove
