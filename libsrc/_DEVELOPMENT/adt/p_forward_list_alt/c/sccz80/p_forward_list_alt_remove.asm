
; void *p_forward_list_alt_remove(p_forward_list_alt_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_remove

EXTERN asm_p_forward_list_alt_remove

p_forward_list_alt_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   jp asm_p_forward_list_alt_remove
