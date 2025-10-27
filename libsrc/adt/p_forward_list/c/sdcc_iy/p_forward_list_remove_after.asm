
; void *p_forward_list_remove_after(void *list_item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_remove_after

EXTERN asm_p_forward_list_remove_after

_p_forward_list_remove_after:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_p_forward_list_remove_after
