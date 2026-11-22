
; void *p_list_prev(void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_prev

EXTERN asm_p_list_prev

_p_list_prev:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_list_prev
