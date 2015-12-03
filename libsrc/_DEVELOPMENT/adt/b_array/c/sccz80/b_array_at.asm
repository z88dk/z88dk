
; int b_array_at(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_at

EXTERN asm_b_array_at

b_array_at:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_array_at
