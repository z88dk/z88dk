
; void *p_forward_list_insert_after(void *list_item, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_insert_after_callee

EXTERN asm_p_forward_list_insert_after

p_forward_list_insert_after_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_p_forward_list_insert_after
