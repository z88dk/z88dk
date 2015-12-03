
; void *p_forward_list_alt_insert_after(p_forward_list_alt_t *list, void *list_item, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_insert_after

EXTERN asm_p_forward_list_alt_insert_after

p_forward_list_alt_insert_after:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af

   jp asm_p_forward_list_alt_insert_after
