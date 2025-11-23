
; int p_forward_list_empty(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_empty

EXTERN asm_p_forward_list_empty

_p_forward_list_empty:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_forward_list_empty
