
; int b_array_at(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_at

EXTERN asm_b_array_at

_b_array_at:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_b_array_at
