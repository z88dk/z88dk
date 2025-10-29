
; int b_array_back(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_back

EXTERN asm_b_array_back

_b_array_back:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_b_array_back
