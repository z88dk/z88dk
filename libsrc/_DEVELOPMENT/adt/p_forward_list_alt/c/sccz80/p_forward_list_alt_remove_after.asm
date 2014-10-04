
; void *p_forward_list_alt_remove_after(p_forward_list_alt_t *list, void *list_item)

SECTION seg_code_p_forward_list_alt

PUBLIC p_forward_list_alt_remove_after

EXTERN asm_p_forward_list_alt_remove_after

p_forward_list_alt_remove_after:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp asm_p_forward_list_alt_remove_after
