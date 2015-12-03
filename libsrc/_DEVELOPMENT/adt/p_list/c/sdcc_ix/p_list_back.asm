
; void *p_list_back(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_back

EXTERN asm_p_list_back

_p_list_back:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_list_back
