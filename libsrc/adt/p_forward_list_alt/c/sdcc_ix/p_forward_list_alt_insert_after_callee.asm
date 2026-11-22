
; void *p_forward_list_alt_insert_after_callee(p_forward_list_alt_t *list, void *list_item, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_insert_after_callee

EXTERN asm_p_forward_list_alt_insert_after

_p_forward_list_alt_insert_after_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   jp asm_p_forward_list_alt_insert_after
