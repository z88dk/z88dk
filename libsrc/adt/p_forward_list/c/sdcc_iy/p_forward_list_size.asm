
; size_t p_forward_list_size(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_size

EXTERN asm_p_forward_list_size

_p_forward_list_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_forward_list_size
